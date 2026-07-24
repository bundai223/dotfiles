---
title: ~/.claude/skillsはdotfiles管理（symlink）
genre: architecture
summary: ~/.claude/skillsはconfig/.claude/skillsへのsymlink。グローバルに入れたスキルは即リポジトリの未追跡ファイルとして現れる。
updated: 2026-07-24
confidence: high
status: active
sources:
  - raw/conversations/2026-07-23_herdr導入とllm-wiki導入.md
  - raw/decisions/0001-exoloop由来スキルはdotfilesに含めない.md
  - raw/decisions/0003-llm-wiki運用スキルを置き換える.md
---

# ~/.claude/skills はdotfiles管理

`~/.claude/skills` は `config/.claude/skills` へのsymlink（`statusline-powerline.js` も同様）。
`~/.claude` のその他（agents / hooks / settings.json 等）はリポジトリ外。

## 帰結

- 「グローバルにスキルを入れる」=「このリポジトリに未追跡ファイルが現れる」。コミットすればマシン間で同期される
- 出所が自分でないスキル（外部ツール由来）は入れるかどうかの線引きが必要
  - exoloop由来の `context-load/` `update-doc/` は `.gitignore` で除外（[decisions/0001](../../../raw/decisions/0001-exoloop由来スキルはdotfilesに含めない.md)）
  - LLM wikiの運用には自作の `load-wiki-as-context/` と `update-wiki/` を使用する。
    両スキルは実装予定（[decisions/0003](../../../raw/decisions/0003-llm-wiki運用スキルを置き換える.md)）
  - `wiki-init/` はexoloop着想だが自作のためコミット
- `.gitignore` に理由コメントは書かず、コミットログに書く
