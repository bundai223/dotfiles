#!/usr/bin/env python3
"""
consult.py - 相談を複数のCLI(LLM)に議論させ、第三者役が要約する汎用オーケストレータ。

思想:
  - エージェントは「argv(コマンド定義) + stance(立場)」だけで定義する。
    stdout に最終回答を吐く CLI なら何でも参加できる (claude / codex / gemini ...)。
  - ラウンドロビンで各エージェントが「これまでの議論記録」を読み、
    直前の発言を批判的に検討してから自説を述べる (安易な同調を避けるため)。
  - 最後に summarizer が全記録を読み、合意/対立/未解決/推奨に整理する。

使い方:
  python3 consult.py "残業ポリシーを月45h上限に統一すべきか"
  echo "相談文..." | python3 consult.py
  python3 consult.py -f soudan.md --rounds 3 --config agents.toml -o out.md

必要環境: Python 3.11+ (tomllib)。設定ファイル未指定時は組み込みの claude+codex を使う。
"""
from __future__ import annotations
import argparse
import subprocess
import sys
import time
import tomllib
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

# ---- 組み込みデフォルト設定 (agents.toml が無くても動く) -------------------
DEFAULT_CONFIG = {
    "rounds": 2,
    "lang": "ja",
    "timeout": 300,
    "agent": [
        {
            "name": "Claude",
            # {prompt} を実プロンプトに置換して argv として渡す (shell を介さない)
            "argv": ["claude", "-p", "{prompt}"],
            "stance": "実務・保守的。前提の妥当性とリスクを重視する。",
        },
        {
            "name": "Codex",
            "argv": ["codex", "exec", "{prompt}"],
            "stance": "技術・攻めの視点。実装可能性と代替案の広さを重視する。",
        },
    ],
    "summarizer": {
        "name": "Claude",
        "argv": ["claude", "-p", "{prompt}"],
    },
}

# ---- プロンプト雛形 (lang で切替) -----------------------------------------
P = {
    "ja": {
        "first": (
            "以下の相談について、あなた({name})の見解を述べてください。\n"
            "結論を先に一文で示し、根拠・前提・リスクを分けて記述すること。冗長な前置きは不要。\n"
            "ツール・ファイル操作・スキルは使わず、テキストのみで直接回答すること。\n"
            "{stance}\n\n# 相談\n{consultation}\n"
        ),
        "turn": (
            "以下は相談と、これまでの議論の記録です。\n"
            "直前までの発言を鵜呑みにせず、弱点・反証・見落とし・リスクを具体的に指摘したうえで、\n"
            "あなた({name})自身の見解を『結論→根拠→前提→残る論点』の順で述べてください。冗長な同調・前置きは不要。\n"
            "ツール・ファイル操作・スキルは使わず、テキストのみで直接回答すること。\n"
            "{stance}\n\n# 相談\n{consultation}\n\n# これまでの議論\n{transcript}\n\n# あなた({name})の番です\n"
        ),
        "summary": (
            "以下は相談と、複数のAIによる議論の全記録です。第三者として日本語で整理してください。\n"
            "共感や前置きは不要。ツール・スキルは使わずテキストのみで回答。次の構成で:\n"
            "1. 結論(先に一文)\n"
            "2. 合意できている点\n"
            "3. 対立・意見が分かれた点(各主張の根拠つき)\n"
            "4. 未解決の論点・確認すべき前提・不明点\n"
            "5. 推奨アクション(条件・トレードオフつき)\n\n"
            "# 相談\n{consultation}\n\n# 議論の全記録\n{transcript}\n"
        ),
        "stance_prefix": "あなたの立場: ",
    },
    "en": {
        "first": (
            "Give your ({name}) view on the following. State the conclusion first, "
            "then separate rationale / assumptions / risks. No filler. Answer directly in text; "
            "do not use tools, file operations, or skills.\n{stance}\n\n"
            "# Question\n{consultation}\n"
        ),
        "turn": (
            "Below is the question and the debate so far. Do not just agree with prior turns: "
            "point out weaknesses, counterarguments, blind spots and risks concretely, then give "
            "your ({name}) own view as conclusion -> rationale -> assumptions -> open issues. "
            "Answer directly in text; do not use tools, file operations, or skills.\n{stance}\n\n"
            "# Question\n{consultation}\n\n# Debate so far\n{transcript}\n\n# Your ({name}) turn\n"
        ),
        "summary": (
            "Below is the question and the full debate among multiple AIs. As a neutral third party, "
            "produce: 1) one-line conclusion 2) points of agreement 3) points of disagreement (with "
            "each side's rationale) 4) open issues / assumptions to verify 5) recommended action "
            "(with conditions and trade-offs). No filler.\n\n"
            "# Question\n{consultation}\n\n# Full debate\n{transcript}\n"
        ),
        "stance_prefix": "Your stance: ",
    },
}


@dataclass
class Agent:
    name: str
    argv: list[str]
    stance: str = ""


@dataclass
class Turn:
    name: str
    round: int
    text: str
    error: bool = False
    seconds: float = 0.0


def resolve_config_path(cli_path: str | None) -> Path | None:
    """設定ファイルの探索順: CLI引数 > $CONSULT_CONFIG > ./agents.toml > スキル同梱 agents.toml"""
    import os
    candidates = []
    if cli_path:
        candidates.append(Path(cli_path))
    if os.environ.get("CONSULT_CONFIG"):
        candidates.append(Path(os.environ["CONSULT_CONFIG"]))
    candidates.append(Path.cwd() / "agents.toml")
    candidates.append(Path(__file__).resolve().parent.parent / "agents.toml")  # スキル直下
    for c in candidates:
        if c.is_file():
            return c
    if cli_path:  # 明示指定が見つからないのはエラー
        raise SystemExit(f"設定ファイルが見つかりません: {cli_path}")
    return None


def load_config(path: str | None) -> dict:
    resolved = resolve_config_path(path)
    if resolved is None:
        return DEFAULT_CONFIG
    print(f"[設定] {resolved}", file=sys.stderr)
    with open(resolved, "rb") as f:
        cfg = tomllib.load(f)
    # 最低限のマージ (未指定キーはデフォルト)
    for k in ("rounds", "lang", "timeout"):
        cfg.setdefault(k, DEFAULT_CONFIG[k])
    if "agent" not in cfg or not cfg["agent"]:
        raise SystemExit("設定に [[agent]] が最低1つ必要です")
    cfg.setdefault("summarizer", DEFAULT_CONFIG["summarizer"])
    return cfg


def run_cli(argv: list[str], prompt: str, timeout: int) -> tuple[bool, str]:
    """argv 内の '{prompt}' を実プロンプトに置換して実行。
    '{prompt}' が無ければ prompt を stdin に流す。戻り値 (ok, text)。"""
    use_stdin = not any("{prompt}" in a for a in argv)
    real_argv = [prompt if a == "{prompt}" else a.replace("{prompt}", prompt) for a in argv]
    try:
        proc = subprocess.run(
            real_argv,
            input=(prompt if use_stdin else None),
            capture_output=True,
            text=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        return False, f"[タイムアウト {timeout}s: {argv[0]}]"
    except FileNotFoundError:
        return False, f"[コマンドが見つかりません: {argv[0]} (PATH/インストールを確認)]"
    out = (proc.stdout or "").strip()
    if proc.returncode != 0:
        err = (proc.stderr or "").strip()[-500:]
        return False, f"[{argv[0]} 異常終了 rc={proc.returncode}] {err or out}"
    if not out:
        return False, f"[{argv[0]} は空の出力を返しました]"
    return True, out


def render_transcript(turns: list[Turn]) -> str:
    return "\n\n".join(f"## {t.name} (round {t.round})\n{t.text}" for t in turns)


def main() -> int:
    ap = argparse.ArgumentParser(description="複数CLIで相談を議論・要約する")
    ap.add_argument("consultation", nargs="?", help="相談文 (省略時は -f か stdin)")
    ap.add_argument("-f", "--file", help="相談文のファイルパス")
    ap.add_argument("-c", "--config", help="agents.toml のパス (省略で組み込み既定)")
    ap.add_argument("-r", "--rounds", type=int, help="発言ラウンド数を上書き")
    ap.add_argument("-l", "--lang", choices=["ja", "en"], help="言語を上書き")
    ap.add_argument("-o", "--output", help="出力Markdownのパス (省略で自動命名)")
    ap.add_argument("--no-summary", action="store_true", help="要約をスキップ")
    args = ap.parse_args()

    # 相談文の取得
    if args.consultation:
        consultation = args.consultation
    elif args.file:
        consultation = Path(args.file).read_text(encoding="utf-8")
    elif not sys.stdin.isatty():
        consultation = sys.stdin.read()
    else:
        ap.error("相談文を引数・-f・stdin のいずれかで渡してください")
    consultation = consultation.strip()
    if not consultation:
        ap.error("相談文が空です")

    cfg = load_config(args.config)
    rounds = args.rounds or cfg["rounds"]
    lang = args.lang or cfg["lang"]
    timeout = cfg["timeout"]
    tpl = P[lang]
    agents = [Agent(a["name"], a["argv"], a.get("stance", "")) for a in cfg["agent"]]

    def stance_line(a: Agent) -> str:
        return (tpl["stance_prefix"] + a.stance) if a.stance else ""

    turns: list[Turn] = []
    first_done = False
    for r in range(1, rounds + 1):
        for a in agents:
            transcript = render_transcript(turns)
            if not first_done:
                prompt = tpl["first"].format(name=a.name, stance=stance_line(a),
                                             consultation=consultation)
                first_done = True
            else:
                prompt = tpl["turn"].format(name=a.name, stance=stance_line(a),
                                            consultation=consultation, transcript=transcript)
            print(f"[{r}/{rounds}] {a.name} 実行中...", file=sys.stderr, flush=True)
            t0 = time.time()
            ok, text = run_cli(a.argv, prompt, timeout)
            dt = time.time() - t0
            if not ok:
                print(f"  警告: {text}", file=sys.stderr)
            turns.append(Turn(a.name, r, text, error=not ok, seconds=dt))

    # 要約
    summary = ""
    if not args.no_summary:
        s = cfg["summarizer"]
        print("要約役 実行中...", file=sys.stderr, flush=True)
        sprompt = tpl["summary"].format(consultation=consultation,
                                        transcript=render_transcript(turns))
        ok, summary = run_cli(s["argv"], sprompt, timeout)
        if not ok:
            print(f"  警告(要約): {summary}", file=sys.stderr)

    # 出力
    ts = datetime.now().strftime("%Y%m%d-%H%M%S")
    out_path = args.output or f"consult-{ts}.md"
    lines = [f"# 議論記録 ({ts})", "", "## 相談", consultation, ""]
    if summary:
        lines += ["## 要約", summary, "", "---", ""]
    lines += ["## 全発言"]
    for t in turns:
        tag = " ⚠失敗" if t.error else ""
        lines += [f"\n### {t.name} — round {t.round}{tag} ({t.seconds:.1f}s)", t.text]
    Path(out_path).write_text("\n".join(lines), encoding="utf-8")

    # stdout には要約(無ければ最終発言)だけ
    print(summary or (turns[-1].text if turns else ""))
    print(f"\n[保存先] {out_path}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
