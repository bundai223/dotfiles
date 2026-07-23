# 2026-07-23 herdr導入とLLM wiki導入（セッション記録）

## 実施内容

### herdrの概念整理

- herdr = AIコーディングエージェント用ターミナルワークスペースマネージャ（https://herdr.dev、tmux的なマルチプレクサ）。導入済みの状態で space / tab / pane / agent の使い分けを整理した
- 階層は workspace(space) → tab → pane → agent の4層
  - workspace: 最上位コンテナ。公式推奨は「1リポジトリ・1タスクにつき1つ」。サイドバーに内包agentの状態が集約される
  - tab: workspace内のレイアウト（ビュー）。agents / logs / server / review など用途別に切る
  - pane: 実PTYのターミナル。分割可、detach後も生存
  - agent: paneの中で起動したclaude等をherdrが**自動検出**したもの。状態（working / blocked / done / idle / unknown）が追跡される。ユーザーが作成・管理する対象ではない
- 実環境の観察: workspace「2ndSystem」1つに 2ndSystem用claude と dotfiles用claude が別タブで同居していた。1リポジトリ=1workspaceへの分割を推奨した（未実施）

### herdrのインストール情報

- 公式: `curl -fsSL https://herdr.dev/install.sh | sh` → `~/.local/bin/herdr` に配置（実環境もこれ。v0.7.5を確認）
- 代替: `brew install herdr` / `mise use -g herdr` / Nix / GitHub releases（ogulcancelik/herdr）手動配置
- 自動更新: `herdr update`。チャネル切替: `herdr channel set stable|preview`
- 対応: Linux x86_64/aarch64、macOS Intel/AS、Windowsはpreviewのみ

### cookbooks/herdr の作成（commit d0970a1）

- macOS: `package 'herdr'`（homebrew）
- Linux: 公式スクリプト実行 + `not_if 'test -x ~/.local/bin/herdr || command -v herdr'`
- gitleaks / lefthook はバージョン固定方式（lefthookは `get_bin_github_release` ヘルパー使用）だが、herdrは本体に自動更新機構があるためcookbook側でバージョン固定しない方針にした（固定すると自動更新と競合する）
- 最近のcookbook（gitleaks / lefthook）はrolesに未登録なので、herdrもrolesには登録しない（ユーザー確認済み）

### スキル・LLM wikiの導入

- runbook skill（Issue→PRの3フェーズ手順書、7/3作成）をコミット（3b8a48b）
- `/wiki-init` でLLM wiki骨組みを導入（0e636a0）: raw/ + wiki/、基本8ジャンル + 固有2ジャンル（tools / environments）、CLAUDE.md新規作成
- `~/.claude/skills` は dotfilesの `config/.claude/skills` へのsymlink。グローバルに入れたスキルは即このリポジトリの未追跡ファイルとして現れる（statusline-powerline.jsも同様のsymlink）
- exoloop由来スキルの扱いを決定 → decisions/0001
- .gitignoreに説明コメントを書いたところ「コメントは不要、書くならcommit logへ」との指摘を受け、コミットを積み直して対応（92c3b14）
- Obsidian vault連携のアイデア → decisions/0002（保留）

## 決定事項

- [0001 exoloop由来スキルはdotfilesに含めない](../decisions/0001-exoloop由来スキルはdotfilesに含めない.md)
- [0002 wikiのObsidian vault連携は保留](../decisions/0002-obsidian-vault連携は保留.md)

## 現在の状態

- main に未pushコミット5つ: d0970a1（herdr cookbook）、3b8a48b（runbook skill）、92c3b14（gitignore）、7c2be6f（wiki-init skill）、0e636a0（wiki骨組み）

## 未解決事項

- push未実施
- herdrのworkspace分割（dotfiles用workspaceの新設）は未実施
- Obsidian vault連携は保留中
