# OpenCode Go 利用検討のための調査

調査日: 2026-07-24

## 依頼

OpenCode Go の利用を検討するため、まず情報収集して整理する。

## 調査結果

### 製品の位置づけ

- OpenCode は MIT License のオープンソースなAIコーディングエージェントで、
  TUI、デスクトップアプリ、IDE拡張として利用できる。
- OpenCode Go は OpenCode 本体ではなく、OpenCodeから利用できる任意の
  モデルプロバイダー兼サブスクリプションである。
- OpenCode自体はGoを契約しなくても、75以上のプロバイダー、ローカルモデル、
  OpenCode Zenなどと組み合わせて利用できる。
- GoはOpenAI互換またはAnthropic互換のAPI endpointを公開しており、
  OpenCode以外の対応エージェントから使うことも想定されている。ただし各エージェント側が
  custom base URLと対象プロトコルに対応している必要がある。

### 料金と利用枠

- 初月は5 USD、その後は10 USD/月。自動更新で、アカウント設定から解約できる。
- 共通の利用上限は5時間あたり12 USD相当、週30 USD相当、月60 USD相当。
- リクエスト回数ではなく、モデル別の単価とトークン使用量で枠を消費する。
  公式のリクエスト数は典型的なキャッシュ利用を前提にした目安であり、保証値ではない。
- 2026-07-24時点の5時間あたりの公式例:
  - Grok 4.5: 120リクエスト
  - GLM-5.2: 880リクエスト
  - Kimi K2.7 Code: 1,350リクエスト
  - MiniMax M3: 3,200リクエスト
  - DeepSeek V4 Flash: 31,650リクエスト
- 多くのモデルは月60 USD相当を基準にするが、Grok 4.5、Kimi K3、
  MiMo-V2.5-Pro、DeepSeek V4 Proは公式表で月15 USD相当を基準にしている。
  「全モデルで一律に60 USD分使える」という意味ではない点に注意する。
- 枠到達後も無料モデルは使える。Zen残高を用意して `Use balance` を有効にすると、
  Goの枠を超えた分を従量課金へフォールバックできる。
- 1 workspaceにつきGoを購読できるのは1 memberのみ。

### 対象モデル

2026-07-24時点で公式文書に記載されているモデル:

- Grok 4.5
- GLM-5.2 / GLM-5.1
- Kimi K3 / Kimi K2.7 Code / Kimi K2.6
- MiMo-V2.5 / MiMo-V2.5-Pro
- MiniMax M3 / MiniMax M2.7
- Qwen3.7 Max / Qwen3.7 Plus / Qwen3.6 Plus
- DeepSeek V4 Pro / DeepSeek V4 Flash
- Hy3

モデルと利用枠は随時変更されると明記されている。GPT、Claude、Geminiなどの
プロプライエタリモデルをGoの定額枠で使うサービスではない。

### プライバシーとセキュリティ

- Goの公式説明では、推論プロバイダーはzero-retentionで、入力をモデル学習に
  使用しないとしている。
- モデルは米国、EU、シンガポールでホストされる。利用者が処理リージョンを固定できるとの
  記載は確認できなかったため、機密データやリージョン要件がある用途では別途確認が必要。
- アカウント等のPersonal Dataはサービス提供、法的義務、紛争解決などに必要な期間
  保持される。推論内容のzero-retentionとアカウント情報の保持は区別する必要がある。
- プロバイダー認証情報は `~/.local/share/opencode/auth.json` に保存される。
  公式文書ではOS keychainを使うとの記載はないため、ファイル権限とdotfilesへの
  誤登録防止を確認する。
- OpenCodeの権限初期値はpermissiveで、ほとんどの操作が `allow`。
  `doom_loop` と `external_directory` は `ask`、`.env`の読み取りは標準で
  `deny`。評価時は `bash`、`edit`、`external_directory`、`git push`などを
  明示的に `ask` または `deny` にする。

### このdotfilesとの互換性

- リポジトリルートの `AGENTS.md` はOpenCodeが直接読み込む。
- `AGENTS.md` がない場合は `CLAUDE.md` をfallbackとして扱う。本リポジトリでは
  `CLAUDE.md` が `AGENTS.md` へのsymlinkであるため、既存の共通指示方針と整合する。
- `~/.claude/skills/` にもfallback互換がある。
- 正式導入を決めた場合は、リポジトリの運用ルールに従い
  `cookbooks/opencode/default.rb` を作り、対象roleまたはbase roleから明示的に
  読み込む。評価段階では一時導入でもよい。
- macOSの公式推奨は `brew install anomalyco/tap/opencode`。
  Homebrew公式formulaの `brew install opencode` は更新が遅い場合がある。

## 評価

### 向いている

- 月10 USD程度に支出を抑えながら複数のopen modelを比較したい。
- 特定ベンダーのモデルに固定せず、タスクごとに速度・品質・利用量を選びたい。
- 既存の `AGENTS.md` / Claude skills資産を再利用したい。
- 低価格モデルで大量の軽量タスク、探索、レビュー、定型修正を回したい。

### 向いていない、または追加確認が必要

- GPT、Claude、Gemini固有の品質・機能が必須。
- モデル構成や利用枠が固定されることを前提にしたい。
- SLA、処理リージョン固定、DPAなどの明示的な企業向け保証が必要。
- どのモデルでも月60 USD相当を必ず使えると期待している。
- 初期状態の広い操作権限を設定せず、そのまま使う。

## 暫定結論

本格採用を即決するのではなく、初月5 USDの1か月評価が妥当。OpenCode Goの価値は
OpenCode本体よりも「open modelへの低価格な定額アクセス」にある。普段の主力を
直ちに置き換えるより、探索・軽量実装・レビューの補助枠として始める。

評価時は候補モデルを2〜3個に絞り、同じ実タスクで次を記録する。

1. 完了率と手戻り回数
2. 初回応答とタスク完了までの時間
3. 5時間・週・月の枠消費
4. tool calling、編集、テスト実行の安定性
5. 日本語指示と既存 `AGENTS.md` の遵守

評価開始時は従量課金への自動fallbackを無効にし、権限を保守的に設定する。

## 参照

- OpenCode Go: https://opencode.ai/docs/go/
- OpenCode Go product page: https://opencode.ai/go
- OpenCode Introduction / Installation: https://opencode.ai/docs/
- Providers: https://opencode.ai/docs/providers/
- Permissions: https://opencode.ai/docs/permissions/
- Rules / AGENTS.md compatibility: https://opencode.ai/docs/rules/
- Configuration: https://opencode.ai/docs/config/
- Privacy Policy: https://opencode.ai/legal/privacy-policy
- Terms of Use: https://opencode.ai/legal/terms-of-service
- GitHub repository: https://github.com/anomalyco/opencode
