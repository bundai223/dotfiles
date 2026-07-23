---
title: herdr — AIエージェント用ターミナルワークスペースマネージャ
genre: tools
summary: 導入は公式スクリプトで~/.local/binへ。自動更新機構（herdr update / channel）を持つためcookbookではバージョン固定しない。
updated: 2026-07-23
confidence: high
status: active
sources:
  - raw/conversations/2026-07-23_herdr導入とllm-wiki導入.md
---

# herdr

AIコーディングエージェント用のターミナルワークスペースマネージャ（tmux的マルチプレクサ）。
https://herdr.dev / GitHub: ogulcancelik/herdr。概念整理は
[concepts/herdr](../concepts/herdr.md) を参照。

## インストール

- 公式（採用）: `curl -fsSL https://herdr.dev/install.sh | sh` → `~/.local/bin/herdr`
- 代替: `brew install herdr` / `mise use -g herdr` / Nix / GitHub releasesから手動配置
- 対応: Linux x86_64/aarch64、macOS Intel/AS。Windowsはpreviewのみ

## 更新

- `herdr update` で自己更新。チャネルは `herdr channel set stable|preview`
- **cookbook（`cookbooks/herdr/`）ではバージョン固定しない**。固定すると自己更新と競合する
  （パターンの詳細: [templates/cookbook-install-patterns](../templates/cookbook-install-patterns.md)）

## 運用メモ

- CLI/socket APIが充実: `herdr api snapshot`（全状態のJSON）、`herdr agent list/prompt/wait` など。エージェント自動化に使える
- 対応agent統合: claude, codex, copilot, cursor, devin, opencode ほか
