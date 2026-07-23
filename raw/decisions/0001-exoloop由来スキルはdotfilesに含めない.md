# 0001 exoloop由来スキルはdotfilesに含めない

- 日付: 2026-07-23
- 状態: 決定

## 決定

- `config/.claude/skills/` の `context-load/` と `update-doc/` はexoloop由来のため `.gitignore` で除外し、dotfilesにはコミットしない
- `wiki-init/` はexoloop（Clickan）のLLM wiki方式に着想を得ているが自作（転写なし）のためコミットする

## 背景

`~/.claude/skills` は dotfilesの `config/.claude/skills` へのsymlinkであり、グローバルに
インストールしたスキルは自動的にリポジトリの未追跡ファイルとして現れる。
2026-07-23にexoloop関連の3スキルが入り、扱いの線引きが必要になった。

## 付随する決定

- `.gitignore` に説明コメントは書かない。理由・経緯はコミットログに書く（commit 92c3b14 のログに本決定の説明を記載）
