---
title: herdr-browser — herdrペイン内Chromiumブラウザプラグイン
genre: tools
summary: herdrのペインにヘッドレスChromiumを描画しCDPで外部ツールから操作するプラグイン。views→connectでエンドポイントを毎回取り直す。WSL+WezTerm環境ではペイン画像が映らない制約あり。
updated: 2026-07-30
confidence: high
status: active
sources:
  - raw/conversations/2026-07-30_herdr-browser動作確認.md
---

# herdr-browser

herdrのペイン内にヘッドレスChromium（`--headless=new`）の画面を描画し、CDP経由で
Playwright / Browser Use / Chrome DevTools MCP などから操作できるようにする
[herdr](herdr.md) のプラグイン。GitHub: ogulcancelik/herdr-browser
（plugin_id: `official.browser`）。Claude Code用スキルは
`config/.claude/skills/herdr-browser/SKILL.md`。

## 接続フロー（毎回この順で）

1. `herdr plugin list --plugin official.browser --json` → `plugin_root` を取得
2. `bun run "<plugin_root>/src/cli.ts" views` → ライブビュー一覧（view_id / pane_id / tabs）
3. `bun run "<plugin_root>/src/cli.ts" connect --view <view_id>` →
   `cdp_http_url` / `browser_ws_url` を取得

**ポートとview_idはセッションごとに変わる**ため、エンドポイントを保存して
使い回さず、毎回 views → connect で取り直す。connect応答に各ツール向けの
接続スニペット（Playwright MCP: `--cdp-endpoint`、Browser Use: `BU_CDP_URL` 等）が
含まれる。

## 運用ノウハウ

- 描画の仕組み: プラグインがCDP screencastで画面を取得し、herdrのgraphics stream
  経由でherdrがkitty image protocolとして端末に描画する。診断は
  `cli.ts metrics`（graphics_stream.active、フレーム数、入力イベント数）が有効
- ペインが真っ黒でもherdr側は正常なことがある。metricsでフレーム送信が続いていれば
  端末側の画像描画の問題 →
  [environments/wsl2-wezterm-kitty-graphics](../environments/wsl2-wezterm-kitty-graphics.md)
- 初期状態は about:blank（真っ白）なので「空のペイン」に見える
- ヘッドレスChromiumからの検索はGoogle・DuckDuckGoともボット検知（CAPTCHA）に
  掛かる。CAPTCHAの解答は人間がペイン（またはミラー）から行う
- ペイン画像が見えない環境では、CDPの `Page.captureScreenshot` +
  `Input.dispatchMouseEvent` をlocalhost HTTPで配信する簡易ミラー（bunで約100行）で
  閲覧・クリック操作を代替できる（2026-07-30に実績あり）

## 導入状態

- インストールは `cookbooks/herdr/default.rb` 末尾で
  `herdr plugin install ogulcancelik/herdr-browser --yes` を実行する
  （herdr本体のプラグインのため専用cookbookは作らない）。冪等性は
  `plugin list --plugin official.browser --json` の plugin_id 有無で判定
- 実体は `~/.config/herdr/plugins/github/` に配置され、更新は
  `herdr plugin install` の再実行（v1に独立したplugin updateは無い）
- Claude Code用スキルは `config/.claude/skills/herdr-browser/SKILL.md`
