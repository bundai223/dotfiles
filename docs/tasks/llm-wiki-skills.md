# LLM Wiki運用スキルの実装

- ステータス: 進行中
- 最終更新日: 2026-07-24

## 目的

LLM Wikiのコンテキスト読み込みと更新を、リポジトリで管理する再利用可能なスキルとして
実装します。

## 完了済み

- [x] 読み込みスキル名を `load-wiki-as-context` に決定
- [x] 更新スキル名を `update-wiki` に決定
- [x] 運用文書と `wiki-init` の生成内容を新しいスキル名へ更新
- [x] 両スキルの責務、基本フロー、安全策、初期実装範囲を整理

## 未完了

- [ ] `load-wiki-as-context` スキルを実装
- [ ] `update-wiki` スキルを実装
- [ ] 各スキルを代表的な作業フローで検証

## 完了条件

- `load-wiki-as-context` が `wiki/SCHEMA.md` の読み込み手順に従って必要なページだけを読み込む
- `update-wiki` が新しい情報を `raw/` に記録し、必要なWikiページ、索引、更新履歴を更新する
- 両スキルの構造とfrontmatterがスキル検証を通過する
- `AGENTS.md` に記載された運用を手動補完なしで実行できる

## 次に行う作業

1. `load-wiki-as-context` の入力、読み込み順、終了時の出力を定義する。
2. `update-wiki` のraw記録、蒸留、矛盾処理、索引更新の手順を定義する。
3. `config/.claude/skills/` に両スキルを実装して検証する。

## 関連文書

- [ADR 0002: LLM Wikiの運用にリポジトリ固有スキルを使用する](../ADR/0002-use-project-owned-llm-wiki-skills.md)
- [Wikiの構造と判断基準](../../wiki/SCHEMA.md)
- [決定記録0003](../../raw/decisions/0003-llm-wiki運用スキルを置き換える.md)
