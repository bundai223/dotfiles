# 0002 wikiのObsidian vault連携は保留

- 日付: 2026-07-23
- 状態: 保留

## 内容

`wiki/`（蒸留層）を Obsidian vault（`~/repos/github.com/bundai223/private-memo/obsidian/work`）
にsymlinkで挿す案。`cookbooks/myrepos/default.rb` にblogリポジトリを同vaultへ
symlinkする前例があり、同じ方式で `<vault>/dotfiles-wiki` を作れる。

wikiページはfrontmatter付きmarkdownでObsidianのプロパティ・グラフビューと相性が良い。

## 保留理由・再開時の論点

- ユーザー判断で一旦保留（2026-07-23）
- 再開時は frontmatterの `sources:` が指す `raw/` への相対リンクがvault側で切れる問題の扱い
  （rawも挿す / リポジトリルートごと挿す / 割り切る）を決めること
