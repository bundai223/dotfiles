---
name: ai-consult
description: >-
  相談・意思決定テーマを複数のCLI AIエージェント（Claude Code / Codex / OpenCode 等、
  モデル個別指定可）に議論させ、合意点・対立点・未解決の前提・推奨アクションに要約するスキル。
  「議論させて」「ディベートして」「多角的に検討して」「セカンドオピニオンが欲しい」
  「ClaudeとCodexで話し合わせて」「FableとSonnetで議論」「複数AIの意見が聞きたい」
  「壁打ちして比較して」など、単一モデルの回答では偏りが心配な相談・技術選定・
  設計判断・方針決定の依頼では必ずこのスキルを使うこと。単純な事実質問には使わない。
---

# ai-consult — 複数CLI AI議論オーケストレータ

相談文を受け取り、設定された複数の CLI エージェントに順番に発言・相互批判させ、
最後に要約役が「合意 / 対立 / 未解決の前提 / 推奨」に整理する。

## 実行手順

1. ユーザーの相談文を確定する。曖昧なら 1 問だけ確認してよいが、基本はそのまま渡す。
2. 次を実行する（`<skill_dir>` はこの SKILL.md のあるディレクトリ）:

   ```bash
   python3 <skill_dir>/scripts/consult.py "相談文" -o consult-result.md
   ```

   長文の相談はファイル経由が安全:

   ```bash
   python3 <skill_dir>/scripts/consult.py -f soudan.md -o consult-result.md
   ```

3. stdout に要約が出る。stderr は進捗ログ。全発言は `-o` の Markdown に保存される。
4. ユーザーには要約を提示し、全記録ファイルの場所を伝える。

## 設定（エージェント構成・モデル指定）

設定ファイルの探索順: `-c PATH` > 環境変数 `CONSULT_CONFIG` > カレントの `agents.toml`
> スキル同梱の `agents.toml`（既定）。

- エージェント追加は `[[agent]]` を増やすだけ。**stdout に最終回答を吐く CLI なら何でも可**。
- モデル指定は argv にフラグを書く:
  - Claude Code: `["claude", "-p", "--model", "claude-fable-5", "{prompt}"]`
  - Codex: `["codex", "exec", "--ephemeral", "-m", "gpt-5.4", "{prompt}"]`
  - OpenCode: `["opencode", "run", "--agent", "plan", "--model", "anthropic/claude-sonnet-4-6", "{prompt}"]`
    （stdin 非対応のため `{prompt}` 引数方式が必須。read-only の plan 推奨）
- `{prompt}` が argv に無い場合はプロンプトを stdin に流す。
- 同じバイナリを `--model` 違いで複数登録すれば「Fable 5 vs Sonnet 4.6」等の
  同一 CLI 別モデル対戦になる。
- 主なオプション: `-r N`(ラウンド数) `-l ja|en` `--no-summary` `-c 設定パス`

ユーザーが「エージェントを増やしたい」「モデルを変えたい」と言ったら、
プロジェクト直下に `agents.toml` をコピーして編集するよう案内する
（スキル同梱の既定を汚さないため）。

## 前提条件と失敗時の対応

- Python 3.11+（`tomllib` 使用、追加パッケージ不要）。
- 使用する各 CLI がインストール済みかつ認証済みであること。
  失敗時はまず単体疎通を確認する: `claude -p "hi"` / `codex exec "hi"` /
  `opencode run "hi"`。
- 個々のエージェントが失敗しても議論は継続し、失敗は記録に `⚠失敗` として残る。
  全滅した場合は認証・PATH の問題をユーザーに報告する。
- 1 呼び出しの timeout は設定の `timeout`（既定 300 秒）。agentic CLI は遅いので
  短くしすぎない。

## Claude Code での実行（重要）

- インストール: `unzip ai-consult.zip -d ~/.claude/skills/`（個人・全プロジェクト共通）
  または `unzip -d <repo>/.claude/skills/`（プロジェクト共有、git にコミット可）。
  ディレクトリ名がそのままコマンドになるため `/ai-consult` で明示起動できる。
- **総実行時間は「エージェント数 × rounds × 各CLIの応答時間」で数分〜十数分になり、
  Bash ツールの既定タイムアウト（約2分）を超える。必ずバックグラウンド実行
  （run_in_background）で起動し、出力ファイルと stderr ログをポーリングして
  完了を待つこと。** フォアグラウンドで実行する場合は timeout を明示的に
  最大まで延ばすこと。

  ```bash
  # 推奨: バックグラウンドで起動して進捗はログを tail
  python3 <skill_dir>/scripts/consult.py "相談文" -o consult-result.md 2> consult-progress.log
  ```

- 入れ子実行になる（Claude Code のセッション内から子プロセスとして `claude -p` を呼ぶ）。
  プロンプト雛形側で「ツール・スキルを使わずテキストのみで回答」を子に指示済みのため、
  再帰トリガーや不要なツール起動はほぼ起きない。
- 逆に「リポジトリの実コードを踏まえた議論」をさせたい場合は、この指示が邪魔になる。
  その場合は相談文にファイルパスと内容を含めて渡すこと（子にツールを使わせるのではなく、
  親である Claude Code 側が必要なコードを読んで相談文に埋め込むのが確実で速い）。

## 注意事項（ユーザーに伝えるべきこと）

- 呼び出し数 = エージェント数 × rounds + 要約 1。コストと時間はこれに比例する。
- 同一プロバイダ同士（例: Fable vs Sonnet）は視点の相関が高く、
  同調バイアスの緩和効果は異ベンダー混成より弱い。
- 結果は非決定的。重要判断では複数回の試行を勧める。
