---
name: wiki-init
description: LLM wiki 方式（raw/ + wiki/ の 2 層ドキュメント）の骨組みを現在のリポジトリに導入する。「wiki を導入して」「LLM wiki をセットアップ」「wiki-init」で使用する。
---

# LLM wiki 骨組みの導入

現在のリポジトリに LLM wiki 方式（記録層 `raw/` + 蒸留層 `wiki/`）の骨組みを生成する。
運用は導入後、セッション開始時の `/load-wiki-as-context` と区切りの
`/update-wiki` で回す。両スキルが未実装の場合は `wiki/SCHEMA.md` の手順を手動で行う。

## 前提チェック

1. git リポジトリであること（`git rev-parse --show-toplevel`）。違えば中止して報告
2. `wiki/` または `raw/` が既に存在する場合は**上書きせず**、現状を報告して指示を仰ぐ

## 生成するもの

### 1. `raw/` — 記録層の骨組み

```
raw/README.md
raw/conversations/.gitkeep
raw/decisions/.gitkeep
raw/issues/.gitkeep
```

`raw/README.md` には次を書く: raw は事実の原本置き場で**追記のみ・書き換え禁止・削除禁止**。
場所と命名の表（conversations/ = `YYYY-MM-DD_トピック.md`、decisions/ = `NNNN-決定内容.md` 連番、
issues/ = `YYYY-MM-DD_番号/`）。ここを根拠に wiki/pages/ へ蒸留すること。

### 2. `wiki/SCHEMA.md` — 構造と判断基準の正本

テンプレを丸写しせず、**そのプロジェクトに合わせて書き起こす**。必ず含める章:

- 2 層の役割（raw = 原本・追記のみ／wiki = 蒸留・LLM 編集可・必ず raw を根拠に）
- 読み方（SCHEMA → index → ジャンル index → 必要ページのみ。全文一括読み禁止）
- ジャンル表: 基本 8 種（user-experiences / architecture / security / infrastructure /
  templates / reviews / concepts / entities）+ プロジェクト固有ジャンル（リポジトリの
  性質から 0〜2 個提案する。例: 予測系なら experiments、運用系なら operations）
- ページの書き方（frontmatter: title / genre / summary / updated / confidence /
  status / sources。sources に根拠 raw を必ず列挙）
- 更新の 4 操作（Create / Update / Split / Synthesis）と log.md 追記規約
  （`- YYYY-MM-DD [操作] ページ名: 一言（根拠 raw）`）
- 矛盾時の扱い（本文を勝手に書き換えず `status: needs-review` + 「未解決の矛盾」節、
  人間が裁定）
- 昇華ルール（同種の知見が raw に 2 回以上現れたらパターンとして蒸留）
- 原本が大きい場合の索引方式（画像入り HTML 等の重い原本は元の場所に置いたまま
  raw/<カテゴリ>/ に索引・要点抽出だけを作り、必要なら .gitignore に原本を追加）

### 3. `wiki/index.md` とジャンルごとの骨組み

- `wiki/index.md`: ジャンル一覧表（説明 + ページ数 0 で初期化）
- 各ジャンルに `wiki/pages/<genre>/index.md`（ページ一覧表の空枠）と
  `wiki/pages/<genre>/log.md`（`# <genre> 更新履歴（追記専用）` のみ）

### 4. `CLAUDE.md` への追記（無ければ作成）

次の節を末尾に追加する:

```markdown
## ドキュメント運用（LLM wiki 方式）

- 構造と基準の正本: `wiki/SCHEMA.md`
- 実装予定の `/load-wiki-as-context` をセッション開始時に、`/update-wiki` を
  作業の区切り・push 前に実行する。実装までは `wiki/SCHEMA.md` の手順を手動で行う
- 新しい情報は必ず `raw/`（不変記録）を経由して `wiki/pages/` に蒸留する
```

## 仕上げ

1. 生成ファイル一覧を表示して確認
2. コミットを提案する（例: `LLM wiki 方式（raw/ + wiki/ 2層）を導入`。
   このリポジトリのコミット言語慣例に従うこと）
3. ユーザーに伝える: グローバル hooks（セッション開始カタログ・push 前リマインド・
   終了時リマインド）は `wiki/index.md` の存在を検出して自動で有効になる

---

出典: 本スキルは exoloop（Clickan）の LLM wiki 方式に**着想を得て** 2026-07-23 に自前で書き起こしたもの。exoloop のファイルからの転写は含まない（exoloop 側に本スキル相当の実体は存在しない）。
