---
title: tree-sitter CLI — 導入方法とGLIBC制約
genre: tools
summary: 公式が案内するprebuilt/binstallはGLIBC 2.39要求でUbuntu 22.04では動かないため、cargoでソースビルドする。
updated: 2026-08-04
confidence: high
status: active
sources:
  - raw/conversations/2026-08-04_Neovim起動エラー復旧.md
---

# tree-sitter CLI

`nvim-treesitter`（mainブランチ）がパーサのビルドに使う。要求される最小バージョンは
`lua/nvim-treesitter/health.lua` の `TREE_SITTER_MIN_VER` にある。

導入は `cookbooks/tree-sitter/`。`roles/base` から読み込む。

## prebuiltバイナリが使えない

公式READMEは3通りを案内するが、このマシン（Ubuntu 22.04 / GLIBC 2.35）では
上2つが使えない。

| 方法 | 結果 |
|---|---|
| `cargo binstall tree-sitter-cli` | 導入は2.5秒で成功するが、GLIBC 2.39要求で実行できない |
| Releasesのprebuilt (`tree-sitter-linux-x64.gz`) | 同上。0.26.1〜0.26.11 全て2.39要求 |
| `cargo install --locked tree-sitter-cli` | 使える（ビルド約5分） |

binstallはprebuiltを取ってくるだけでGLIBCの互換性を検査しない。導入成功と
実行可能は別なので、入れた直後に `tree-sitter --version` を必ず実行する。

`cargo binstall --strategies compile` でソースビルドへ倒せるが、
`--install-path` を受け付けないため配置先を指定できない。素直に
`cargo install --root` を使う。

## 配置先を ~/.local/bin にする理由

asdfのshimは `~/.asdf/shims` としてPATHの先頭付近に入り、`/usr/local/bin` や
`~/.local/bin` より先に解決される。以前は `cookbooks/rust` の
`.default-cargo-crates` に `tree-sitter-cli` を書いてasdf配下へ入れていたが、
この方式には次の問題があった。

- CLIのバージョンがasdfのRustバージョンに引きずられる。実際 `rust 1.76.0` の
  ピンが2024年当時のまま残り、CLIも 0.20.8 のまま更新されず
  `tree-sitter build` サブコマンドが無い状態になっていた。
- `.default-cargo-crates` は全crateを同列に扱うため、
  「nvim-treesitterが要求するバージョン」を表明できない。

そのため専用cookbookへ切り出し、`cargo install --root ~/.local` で
配置先を固定した。移行時はasdf側の古いバイナリとshimを消して
`asdf reshim rust` する必要がある（消さないとshimが先に解決される）。
