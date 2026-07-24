---
title: LLM Wiki運用スキルの責務
genre: architecture
summary: load-wiki-as-contextは必要な知識の選択的な読み込み、update-wikiはraw記録とWikiへの蒸留を担当する。
updated: 2026-07-24
confidence: medium
status: active
sources:
  - raw/decisions/0003-llm-wiki運用スキルを置き換える.md
  - raw/conversations/2026-07-24_llm-wiki運用スキル設計.md
---

# LLM Wiki運用スキルの責務

LLM Wikiの読み込みと更新は、読み取り専用の `load-wiki-as-context` と、記録・蒸留を行う
`update-wiki` に分離する。両スキルは実装前であり、このページは現在の設計方針を示す。

## `load-wiki-as-context`

現在の作業に必要なWikiページだけを選択して読み込み、適用する知識と注意事項を報告する。

読み込み順:

1. `wiki/SCHEMA.md`
2. `wiki/index.md`
3. 関連ジャンルの `index.md`
4. 必要なWikiページ
5. 根拠確認が必要な場合だけ `sources` のraw記録

全ページの一括読み込みとファイル変更は行わない。`status`、`confidence`、未解決の矛盾を
考慮し、Wikiに関連情報がなければそのことを明示する。

## `update-wiki`

会話、変更差分、検証結果、決定事項から長期的に有用な情報を選び、最初に `raw/` へ
不変記録を作成してからWikiへ蒸留する。

更新時は既存ページを検索し、`Create`、`Update`、`Split`、`Synthesis` のいずれかを
選ぶ。ページのsources、ジャンルの `index.md` と `log.md`、必要に応じて
`wiki/index.md` のページ数を整合させる。

既存rawの編集・削除、秘密情報の保存、根拠のない主張の追加、矛盾する内容の自動上書き、
コミット、pushは行わない。

## 初期実装の範囲

- `load-wiki-as-context`: 選択的読み込みと、読み込んだページ・要点の報告
- `update-wiki`: conversation rawの新規作成、既存ページ検索、CreateまたはUpdate、
  sources・索引・更新履歴の検証

`Split`、`Synthesis`、矛盾処理の高度化は後続の改善対象とする。`update-wiki` は誤った知識を
長期保存しないよう、初期段階では判断の自由度を低くする。
