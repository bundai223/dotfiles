---
title: Neovim — メンテナンスと互換性対応
genre: tools
summary: 起動エラーを先に再現し、古い設定形式と更新停止プラグインを対象単位で修正する。
updated: 2026-08-04
confidence: high
status: active
sources:
  - raw/conversations/2026-07-28_Neovimエラー復旧.md
  - raw/conversations/2026-08-04_Neovim起動エラー復旧.md
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

## 起動エラーの切り分け順序

起動エラーは1つ直すと次が現れることがある。前のエラーが後のエラーを隠している
だけなので、1つずつ直しては再現を取り直す。

1. **プラグインの作業ツリー破損を疑う** — `module '...' not found` が出たら、
   まず `git -C <plugin-dir> status --short`。lazy.nvimの更新が中断すると
   新旧ファイルが混在し、`git restore .` で直る。
2. **treesitterのパーサとクエリの整合** — `Invalid field name` はクエリが新しく
   パーサが古い。`Parser could not be created` はパーサが見つかっていない。
3. **rtpにパーサディレクトリが残っているか** — `nvim_get_runtime_file('parser/<lang>.so', true)`
   で実際に読まれる場所を確認する。
4. **LSPへ渡す設定テーブルの形** — 配列とハッシュを混ぜたLuaテーブルは
   `Invalid 'data': Cannot convert given Lua table` になる。

## nvim-treesitter（mainブランチ）

- パーサのビルドに `tree-sitter` CLIを使う。必要な最小バージョンは
  `lua/nvim-treesitter/health.lua` の `TREE_SITTER_MIN_VER` にある。
  導入は [tree-sitter-cli](tree-sitter-cli.md) を参照。
- パーサの配置先は `setup({ install_dir = ... })` で決まる。旧 `master` ブランチは
  プラグインディレクトリ配下の `parser/` に置いていたため、移行後もそれが残っていると
  rtp上で先に見つかり新しい配置先を隠す。移行時は旧 `parser/` `parser-info/` を消す。
- ヘッドレスで `require('nvim-treesitter').install({...}):wait(n)` を使うと
  ダウンロードから進まない。`:TSInstall <langs>` + `sleep` で待つ。

## lazy.nvim が nvim 同梱パーサを rtp から落とす

lazy.nvimはrtpリセット時のlibdirを「`<prefix>/lib64` があればそちら、無ければ
`<prefix>/lib`」で決める。`/usr/local/lib64` が存在し、かつnvimのパーサが
`/usr/local/lib/nvim` にある環境では同梱パーサが丸ごとrtpから消える。

`lazy.setup` の `performance.rtp.paths` に実在する側を明示的に足して回避する
（`config/.config/nvim/lua/plugins.lua` の `nvim_lib_dirs()`）。
自前でパーサを入れていると症状が出ないため、パーサを入れ直すまで気付きにくい。

## lazy-lock.json の固定先が古いとプラグインが壊れる

ロック先の旧コミットと現在のリモートで「同じパスが通常ファイル / サブモジュール」と
食い違っていると、lazyのcheckoutが中断する。このとき**作業ツリーだけ書き換わった
中途半端な状態が残る**ため、`module '...' not found` のような症状になる。

```
fatal: could not reset submodule index
error: The following untracked working tree files would be overwritten by checkout
```

`git restore .` で一時的に直っても、次の `Lazy update` で再発する。
プラグインディレクトリごと削除してクリーンに入れ直し、`lazy-lock.json` を
新しいコミットへ進める。

## パーサが無いfiletypeでプラグインが落ちる

nvimは途中から、パーサが無いとき `vim.treesitter.get_parser` がエラーではなく
**nilを返す**ようになった（neovim commit `fd1e019`）。この変更前のプラグインは
nilをそのまま参照して落ちる。`~/.gitconfig`（`git_config`）のように
パーサを入れていないfiletypeで初めて表面化する。

プラグイン側を新しくするのが本筋。切り分けでは、ヘッドレス起動だと
`VimEnter` 依存のプラグインがロードされず再現しない点に注意する
（`Lazy! load <plugin>` で明示的にロードして再現させる）。

## lua_ls の workspace.library

配列形式で書く。ハッシュ形式（`[path] = true`）と混ぜると
`workspace/didChangeConfiguration` の送信時に
`Invalid 'data': Cannot convert given Lua table` で落ちる。
