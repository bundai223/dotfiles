---
title: OpenCode Go — open coding modelの低価格サブスクリプション
genre: tools
summary: 初月5 USD、以後10 USD/月で複数のopen coding modelを使える。主力の即時置換ではなく、権限を絞った1か月評価から始める。
updated: 2026-07-24
confidence: medium
status: active
sources:
  - raw/conversations/2026-07-24_opencode-go調査.md
---

# OpenCode Go

OpenCode Goは、OpenCode本体とは独立した任意のモデルサブスクリプション。
OpenCodeはオープンソースのエージェントであり、Goを契約しなくても他のproviderや
local modelで利用できる。

## 暫定判断

初月5 USDの1か月評価から始める価値がある。ただし、既存の主力エージェントを
直ちに置き換えるのではなく、探索・軽量実装・レビュー用の補助枠として評価する。

## 料金と制約（2026-07-24時点）

- 初月5 USD、以後10 USD/月の自動更新
- 上限は5時間12 USD相当、週30 USD相当、月60 USD相当
- 消費量はリクエスト数ではなく、モデル別単価とトークン量で決まる
- 一部モデルは公式表上の月額換算が15 USD相当で、全モデル一律に60 USD分ではない
- 上限到達後は無料モデルを利用できる
- Zen残高への従量課金fallbackは任意。評価中は無効にして予算を固定する
- モデル一覧と利用枠は変更されるため、契約時に公式ページを再確認する

対象はGLM、Kimi、MiniMax、Qwen、DeepSeek、MiMoなどのopen coding modelが中心。
GPT、Claude、GeminiをGoの定額枠で利用するプランではない。

## セキュリティ

- Goの推論providerはzero-retentionで、学習に使わないと公式に説明されている
- 処理拠点は米国、EU、シンガポール。リージョン固定が必要な用途は追加確認する
- 認証情報は `~/.local/share/opencode/auth.json` に保存されるため、
  ファイル権限とGitへの誤登録を確認する
- OpenCodeの標準権限は許可寄り。評価開始前に最低限次を設定する
  - `bash`: 原則 `ask`
  - `edit`: `ask`
  - `external_directory`: `ask`または`deny`
  - `git push`など外部変更: `deny`または個別に`ask`

## このリポジトリとの統合

OpenCodeはルートの `AGENTS.md` を直接利用できる。`CLAUDE.md`と
`~/.claude/skills/`にもfallback互換があり、既存資産を再利用しやすい。

正式採用時は `cookbooks/opencode/default.rb` を作り、対象roleまたはbase roleから
明示的に読み込む。macOSの公式推奨インストール元は
`anomalyco/tap/opencode`。

## 評価項目

同じ実タスクを2〜3モデルで実行し、完了率、手戻り、速度、枠消費、tool callingの
安定性、日本語指示と `AGENTS.md` の遵守を比較する。結果が蓄積するまでは
モデル品質と費用対効果を確定評価しない。
