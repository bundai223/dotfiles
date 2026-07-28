---
title: Neovim — メンテナンスと互換性対応
genre: tools
summary: 起動エラーを先に再現し、古い設定形式と更新停止プラグインを対象単位で修正する。
updated: 2026-07-28
confidence: high
status: active
sources:
  - raw/conversations/2026-07-28_Neovimエラー復旧.md
---

# Neovim

## 復旧方針

- `bin/nvim-maintenance-check` で起動と `:checkhealth` を先に記録する。
- providerのネットワーク検査と、設定・プラグイン由来のエラーを分けて扱う。
- 複数プラグインを一括更新せず、再現できた警告の発生元ごとに修正する。
- 更新が止まったプラグインの互換APIを設定側で隠さず、後継への移行または削除を選ぶ。

## 既知の対応

- `cmp-dictionary` の `document` はtable形式であり、説明表示を使わない場合は指定しない。
- `symbols-outline.nvim` は `outline.nvim` へ移行済み。コマンドは
  `SymbolsOutline` ではなく `Outline` を使う。
- `nlsp-settings.nvim` は削除済み。JSON schemaは既存のSchemaStoreカタログと
  リポジトリ固有schemaから構成する。
- `mason-lspconfig.nvim 2.x` では `setup_handlers()` を使わない。個別設定は
  `vim.lsp.config()` で定義し、Masonがインストール済みserverを自動で有効化する。
- 更新が止まった `rust-tools.nvim` は削除済み。`rust_analyzer` は標準のLSP設定を使う。
- `nvim-notify` は `Notifications` と `NotificationsClear` をコマンドによる遅延ロード条件に
  含め、設定時に `require("notify").setup({})` を実行する。`require("notify")` だけでは
  両コマンドは登録されない。
- `E348: No string under cursor` は、文字列のない位置で `*` や `#` を実行した場合の
  Neovim本体の標準メッセージであり、プラグイン障害ではない。
