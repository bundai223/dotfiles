# wiki SCHEMA — 構造と判断基準の正本

このリポジトリ（bundai223/dotfiles）は mitamae ベースの環境構築リポジトリ
（`cookbooks/` = ツール導入レシピ、`roles/` = マシン種別ごとの適用セット、
`config/` = 各ツールの設定ファイル）。この wiki はコードから読み取れない知見
（選定理由・ハマりどころ・環境差分・運用判断）を蓄積する。

## 2 層の役割

| 層 | 役割 | 編集ルール |
|---|---|---|
| `raw/` | 事実の原本（会話記録・決定・問題） | 追記のみ。書き換え・削除禁止 |
| `wiki/` | raw から蒸留した知見ページ | LLM が編集してよい。ただし**必ず raw を根拠にする** |

## 読み方（コンテキスト読み込み手順）

1. `wiki/SCHEMA.md`（このファイル）
2. `wiki/index.md` でジャンル一覧とページ数を見る
3. 関係するジャンルの `wiki/pages/<genre>/index.md` を見る
4. 必要なページだけ読む

**全ページの一括読み込みは禁止**。必要なものだけ辿る。

## ジャンル表

| ジャンル | 内容 |
|---|---|
| `user-experiences` | ツール・設定の使用感、ハマりどころの体験記録 |
| `architecture` | このリポジトリ自体の構成（cookbooks / roles / lib / bin/deploy の流れ）に関する設計知見 |
| `security` | 秘密情報の扱い、gitleaks / git-secrets などの検出・防止の運用 |
| `infrastructure` | 実行基盤の知見（mitamae、WSL2、各 OS のパッケージ事情） |
| `templates` | 定型パターン（cookbook の書き方、`get_bin_github_release` の使い方など） |
| `reviews` | 変更レビューで得た指摘・観点 |
| `concepts` | 概念整理（例: herdr の space / tab / pane / agent） |
| `entities` | 依存する外部ツール・サービスの実体情報（URL、更新方式、チャネル） |
| `tools` | **[固有]** 導入ツールの選定理由・比較・運用ノウハウ（herdr, gitleaks, lefthook…） |
| `environments` | **[固有]** マシン / OS 環境ごとのセットアップ知見（WSL2 / arch / darwin / ubuntu の差分） |

## ページの書き方

`wiki/pages/<genre>/<ページ名>.md`。frontmatter は必須:

```markdown
---
title: ページタイトル
genre: tools
summary: 1〜2 文の要約
updated: YYYY-MM-DD
confidence: high | medium | low
status: active | needs-review | deprecated
sources:
  - raw/conversations/2026-07-23_herdr導入.md
---
```

- `sources` には根拠となる raw を**必ず**列挙する。raw に無い主張を書かない
- 本文は結論を先頭に。経緯は raw に任せ、ページには蒸留結果だけを書く

## 更新の 4 操作と log.md

| 操作 | いつ |
|---|---|
| Create | 新しい知見のページ化 |
| Update | 既存ページへの追記・修正（新しい raw が根拠） |
| Split | ページが肥大化したら分割 |
| Synthesis | 複数ページ・複数 raw を横断してパターンを抽出 |

操作したら該当ジャンルの `log.md` に追記する（追記専用）:

```
- YYYY-MM-DD [Create] herdr: 導入と概念整理（raw/conversations/2026-07-23_herdr導入.md）
```

ページを増減したらジャンルの `index.md` と `wiki/index.md` のページ数も更新する。

## 矛盾時の扱い

新しい raw が既存ページと矛盾しても、本文を勝手に書き換えない。

1. ページを `status: needs-review` にする
2. ページ末尾に「## 未解決の矛盾」節を作り、両論と根拠 raw を併記する
3. 裁定は人間が行い、裁定結果を raw/decisions/ に記録してから本文を直す

## 昇華ルール

同種の知見が raw に **2 回以上**現れたら、個別事例ではなくパターンとして
蒸留する（多くは `templates` か `tools` 行き）。
例: 「バイナリ配布ツールの cookbook はバージョン固定、自動更新持ちは固定しない」。

## 原本が大きい場合の索引方式

画像入り HTML・長大ログなどの重い原本は元の場所に置いたまま、
`raw/<カテゴリ>/` には**索引と要点抽出だけ**を作る（元ファイルへのパスを明記）。
リポジトリに入れたくない原本は `.gitignore` に追加してよい（索引は残す）。
