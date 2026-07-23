---
title: herdrの概念モデル（space / tab / pane / agent）
genre: concepts
summary: herdrはworkspace(space)→tab→pane→agentの4層。上3層は入れ物で、agentだけはpane内プロセスの自動検出。
updated: 2026-07-23
confidence: high
status: active
sources:
  - raw/conversations/2026-07-23_herdr導入とllm-wiki導入.md
---

# herdrの概念モデル

| 概念 | 何か | 使い分け |
|---|---|---|
| space (workspace) | 最上位コンテナ | **1リポジトリ・1タスクにつき1つ**。サイドバーに内包agentの状態が集約され、「どのプロジェクトが手待ちか」を見る単位 |
| tab | space内のレイアウト（画面） | 同一プロジェクト内のビュー切替（エージェント用 / ログ用 / サーバ用 / レビュー用など） |
| pane | tab内の実ターミナル（PTY） | 分割して並べる単位。detachしても生存 |
| agent | paneの中でherdrが**自動検出**したAIプロセス | 作成・管理する対象ではない。claude等を起動すると認識され working / blocked / done / idle が追跡される |

## 要点

- 普段の操作で考えるのは「spaceとtabをどう切るか」だけ。agentは勝手に検出される
- 複数リポジトリを1つのworkspaceに同居させると、サイドバーのプロジェクト単位の状態集約が効かない（1リポジトリ=1workspaceに分ける）
- 操作: 右クリックメニュー / `herdr workspace create` / `herdr tab create`。prefixキーはtmux互換のctrl+b
