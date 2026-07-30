# 2026-07-30 herdr-browser動作確認とWezTerm表示問題の調査（セッション記録）

## 実施内容

### herdr-browserプラグインの動作確認

- herdr-browser = herdrのペイン内にヘッドレスChromiumの画面を描画し、CDP経由で
  外部の自動化ツール（Playwright / Browser Use等）から操作できるようにするプラグイン
  （GitHub: ogulcancelik/herdr-browser、plugin_id: official.browser、v0.1.0）
- Claude Code用スキルを `config/.claude/skills/herdr-browser/SKILL.md` に配置済み（未コミット）
- 動作確認フロー（すべて成功）:
  1. `herdr plugin list --plugin official.browser --json` で `plugin_root` を取得
     （`~/.config/herdr/plugins/github/official.browser-<hash>/`）
  2. `bun run "<plugin_root>/src/cli.ts" views` でライブビュー一覧
     （view_id / pane_id / tabs が返る）
  3. `bun run "<plugin_root>/src/cli.ts" connect --view <view_id>` で
     view単位の `cdp_http_url`（例: http://127.0.0.1:40305）と `browser_ws_url` を取得
  4. CDP（Page.navigate / Runtime.evaluate / Input.insertText /
     Input.dispatchKeyEvent / Page.captureScreenshot）で example.com への遷移、
     Google・DuckDuckGoでの検索入力、スクリーンショット取得まで動作
- connect応答には各ツール向け接続スニペットが含まれる（Playwright MCP:
  `--cdp-endpoint=<url>`、Browser Use: `BU_CDP_URL=<url>`、Chrome DevTools MCP:
  `--browser-url=<url>`）
- ポートとview_idはセッションごとに変わるため、毎回 views → connect で取り直す
- Chromiumは `--headless=new` で起動され、画面はプラグインがCDP screencastで取得して
  herdrのgraphics stream（デフォルト`herdr-stream`トランスポート）に送り、
  herdrがkitty image protocolで端末に描画する構造
- `cli.ts metrics` でフレーム送信数・graphics_stream.active・入力イベント数を確認できる
- 検索エンジン側の注意: ヘッドレスChromiumからの検索はGoogle（reCAPTCHA）も
  DuckDuckGo（画像CAPTCHA）もボット検知に掛かった。CAPTCHAは人間がペイン
  （またはミラー）から解く必要がある

### WezTermでブラウザペインが真っ黒になる問題の診断

- 環境: Windowsネイティブ版WezTerm（stable 20240203）から `wsl.exe` でWSL2
  （Ubuntu 22.04）に入り、その中でherdr 0.7.5を実行。
  `~/.config/herdr/config.toml` に `[experimental] kitty_graphics = true`
- 症状: Browserペインはレイアウト上存在し（`herdr pane layout` で確認）、
  ツールバーのテキストは `herdr pane read` で見えるが、ページ画像領域が真っ黒
- 診断過程: plugin metricsでgraphics_streamはactive・フレーム送信継続を確認
  → herdr側は正常で、端末への画像描画だけが失敗していると切り分け
- 原因: WindowsのConPTY層がkitty graphicsのエスケープシーケンスを飲み込むため、
  wsl.exe経由の経路では画像データがWezTermに届かない
  - wezterm/wezterm#1673（2022年からopen、2026-07時点も未解決）が本体issue
  - wezterm#5757は#1673のduplicateとしてclose（修正ではない）
  - 前提のmicrosoft/terminal#1173は解決済みだがwezterm側の対応なし
  - **WezTerm nightlyでも未修正**（changelogにConPTY通過の修正なし）
  - WSLではさらにwezterm#6781（ピクセルサイズが0x0で取れない）もある

### 回避策と選択肢

- 即席の回避策として、CDPスクリーンショットをlocalhost HTTPで配信する
  簡易ミラー（bunスクリプト、約100行）を作成。Windows側ブラウザで
  `http://localhost:18777` を開くと約0.7秒間隔で画面が更新され、
  画像上のクリックがCDP `Input.dispatchMouseEvent` でブラウザに転送される。
  これでDuckDuckGoのCAPTCHA通過に成功（人間がミラー経由で解いた）
- 恒久対応の選択肢（有望順）:
  1. WezTermの `wsl_domains`（mux経由）— ConPTYを回避できる可能性。設定のみで試せる
  2. `wezterm ssh` でWSLへ — wez本人が#1673で提示した回避策。WSL側にsshdが必要。
     mux/ssh経由の画像性能問題（#1237）は2022年に修正済み
  3. WSLgでkitty / Ghosttyを動かす — kitty protocolのリファレンス実装で確実
- herdrの `kitty_graphics` はexperimental扱い。「Windows版WezTerm + WSLで真っ黒」は
  herdrへのissue報告候補

## 決定事項

- なし（回避策の恒久化は未決定。ミラーはセッション限りの一時スクリプト）

## 現在の状態

- herdr-browserプラグイン・スキルは動作確認済み（CDP操作・入力・スクショまで）
- ペインの画像表示はWezTerm(Windows)+WSL環境では不可。ミラーで代替した
- スキルファイル `config/.claude/skills/herdr-browser/` は未コミット

## 未解決事項

- wsl_domains / wezterm ssh / WSLg のどれで恒久対応するか未検証・未決定
- herdr-browserスキルのコミットと、継続利用する場合のcookbook化判断
  （プラグイン自体は `herdr plugin install` 管理でありmitamae対象外の可能性が高い）
- 「herdrのプラグインで人気のもの」調査は途中（起点: GitHubトピック
  `herdr-plugin`、`ogulcancelik/herdr-plugin-examples`、herdr.dev/ja/docs/plugins/）

## 追記（2026-07-30 同日）: cookbook化の決定

- herdr-browserを継続利用すると決定し、インストールをcookbookに追加した
- 新規 `cookbooks/herdr-browser/` は作らず、**既存 `cookbooks/herdr/default.rb` の
  末尾に追記**する方式をユーザーが指定（herdr本体のプラグインであり、
  `herdr plugin install` 管理で導入経路もherdr CLIのため）
- 実装: `herdr plugin install ogulcancelik/herdr-browser --yes` を execute で実行。
  冪等性は `herdr plugin list --plugin official.browser --json` の
  `"plugin_id":"official.browser"` 有無で判定（not_if）。
  herdrのパスは `command -v herdr` に `~/.local/bin/herdr` フォールバック
  （同一実行内でherdrを入れた直後のPATH未反映対策、本体インストールのnot_ifと同じ考え方）
- プラグインはmacOS/Linux両対応のためcaseブロックの外に配置（未対応OSは手前のraiseで到達しない）
