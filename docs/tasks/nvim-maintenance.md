# Neovimメンテナンスと復旧

- ステータス: 進行中
- 最終更新日: 2026-07-28

## 目的

Neovimの通常利用時に発生するエラーを解消し、プラグイン更新後も遅延ロードを含む
主要な編集操作を再現可能な方法で検証できる状態にします。

## 完了済み

- [x] ヘッドレス起動と `:checkhealth` を収集する診断スクリプトを追加
- [x] Neovimメンテナンス手順を文書化
- [x] lazy.nvimの遅延ロードを考慮した二層テスト方針をADR 0001として記録
- [x] 現在のNeovimバージョンが `0.12.4` であることを確認
- [x] ヘッドレスでの初期起動が終了コード `0` であることを確認
- [x] `cmp-dictionary` の古いdocumentオプションを削除
- [x] `symbols-outline.nvim` を後継の `outline.nvim` へ移行
- [x] `nlsp-settings.nvim` を削除し、JSON schema設定を既存のSchemaStoreへ集約
- [x] `vim.lsp.buf_get_clients()` の非推奨警告が出ないことを再現手順で確認
- [x] `mason-lspconfig.nvim 2.2.0` に合わせて `vim.lsp.config()` 方式へ移行
- [x] 更新停止中の `rust-tools.nvim` を削除し、標準の `rust_analyzer` 設定へ移行
- [x] ファイルを開く前でも `:Notifications` と `:NotificationsClear` を利用可能に修正

## 未完了

- [ ] lazy.nvimの全ロードテストを実装
- [ ] 遅延ロードのシナリオテストを実装
- [ ] 通常の画面起動時に発生するエラーと操作手順を収集
- [ ] `lazy-lock.json` をリポジトリ管理へ移行
- [ ] 起動時に必要なプラグインとNeovim本体との互換性を修正
- [ ] Treesitterを修正・更新
- [ ] LSP、Mason、補完、スニペット、フォーマッターを修正・更新
- [ ] その他のプラグインをグループ単位で修正・更新
- [ ] 開発停止または未使用のプラグインと設定を整理
- [ ] 代表的な編集操作を対話的に確認

## 完了条件

- `bin/nvim-maintenance-check` が正常終了する
- 全ロードテストが正常終了する
- 代表的な遅延ロードシナリオが正常終了する
- 通常起動時に既知のエラーが表示されない
- 日常的に使用するFileTypeでLSP、補完、Treesitter、フォーマットが動作する
- `lazy-lock.json` によりプラグインのバージョンを再現できる

## 次に行う作業

1. 今回修正した補完とアウトラインを通常画面で対話的に確認する。
2. 全ロードテストとシナリオテストの実装対象を、現在のlazy.nvim定義から抽出する。
3. 通常起動時のエラーを、操作手順とともに診断レポートへ収集できるようにする。
4. 現在の `~/.config/nvim/lazy-lock.json` を確認し、リポジトリへの配置方法を決める。

## 関連文書

- [Neovimメンテナンス手順](../nvim-maintenance.md)
- [ADR 0001: lazy.nvimの遅延ロードを考慮した二層テスト](../ADR/0001-test-lazy-loaded-neovim-plugins-in-two-layers.md)
- [2026-07-28 Neovimエラー復旧記録](../../raw/conversations/2026-07-28_Neovimエラー復旧.md)
