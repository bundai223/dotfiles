---
title: WSL2 + Windows版WezTermではkitty graphicsが表示されない
genre: environments
summary: WindowsのConPTY層がkitty graphicsのエスケープを飲み込むため、wsl.exe経由では端末内画像が真っ黒になる。WezTerm nightlyでも未修正。回避はwsl_domains / wezterm ssh / WSLg。
updated: 2026-07-30
confidence: high
status: active
sources:
  - raw/conversations/2026-07-30_herdr-browser動作確認.md
---

# WSL2 + Windows版WezTermではkitty graphicsが表示されない

Windowsネイティブ版WezTermから `wsl.exe` でWSL2に入る構成では、kitty image
protocolを使うアプリ（herdrの `kitty_graphics`、snacks.nvim等）の画像が
**表示されない（黒い矩形になる）**。アプリ側は正常でも起きる。

## 原因

WindowsのConPTY層がkitty graphicsのエスケープシーケンスを飲み込むため、
画像データがWezTermに到達しない。

- 本体issue: wezterm/wezterm#1673（2022年からopen、2026-07時点も未解決）。
  #5757はそのduplicateとしてclose（修正ではない）
- **WezTerm nightlyに更新しても直らない**（changelogにConPTY通過の修正なし）
- WSLではさらにピクセルサイズが0x0で取れない問題（wezterm#6781）もある

## 切り分け方

アプリ側（herdr等）が画像フレームを送信し続けているのに黒い場合は端末側の問題。
herdr-browserなら `cli.ts metrics` の `graphics_stream.active` とフレーム数で
確認できる（[tools/herdr-browser](../tools/herdr-browser.md)）。

## 回避策（有望順・2026-07-30時点で未検証）

1. WezTermの `wsl_domains`（mux経由でWSLに入る）— ConPTYを回避できる可能性。
   設定のみで試せる
2. `wezterm ssh` でWSLへ — wez本人が#1673で提示。WSL側にsshdが必要。
   mux/ssh経由の画像性能問題（#1237）は2022年に修正済み
3. WSLgでkitty / Ghosttyを動かす — kitty protocolのリファレンス実装で確実だが
   ターミナル乗り換えになる

一時しのぎとしては、アプリ側で画像をlocalhost HTTP配信してWindows側ブラウザで
見る方法がある（herdr-browserのミラーで実績あり）。
