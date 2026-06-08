---
name: glab-mr-review
description: GitLab CLI (glab) でマージリクエスト(MR)をレビュー・承認・コメント投稿するためのレビュー基準・チェックリスト・コメントテンプレート・運用ルール。ユーザーが「MR」「マージリクエスト」「!123」「レビューして」「指摘して」「approve」「マージ」などに言及したとき、または GitLab の MR URL を共有したときに使用する。AI レビューによるコメント投稿の運用ガードレールを含む。
---

# glab を使った MR レビュー支援

GitLab CLI (`glab`) でマージリクエスト (MR) をレビュー・承認・コメント投稿するための手順、レビュー基準、コメントテンプレート、AI レビュー運用ルールをまとめる。
社内 Self-Managed GitLab (`gitlab-system-dev.k-idea.jp` など) を主想定とする。git プロトコルは SSH / HTTPS のどちらでも動作する。

## 0. 前提確認

```bash
glab auth status                      # 認証済みか
glab config get host                  # 既定ホスト (社内 GitLab であること)
glab config get git_protocol          # ssh または https (個人の好み)
```

未認証なら `gitlab-cli-toolkit/docs/03-auth-config.md` の手順を案内する。
環境がおかしい場合は `bash scripts/doctor.sh` を実行して総点検。

リポジトリ内で作業する場合は、対象 MR のあるリポジトリのワーキングディレクトリにいることを確認(`pwd` / `git remote -v`)。

## 1. レビュー対象の特定

### 自分宛に来ている MR の一覧

```bash
glab mr list --reviewer=@me
glab mr list --assignee=@me
```

### IID / URL からの特定

- `glab mr view 123` (IID 直指定)
- `glab mr view https://gitlab-system-dev.k-idea.jp/group/project/-/merge_requests/123` (URL 直指定)
- 現在のブランチに紐づく MR: `glab mr view`(引数省略)

## 2. 概要把握 / 差分 / チェックアウト / CI

### 概要

```bash
glab mr view <iid>
```

タイトル、説明、source/target ブランチ、CI ステータス、approvers、discussions が一画面で確認できる。`--web` でブラウザを起動。

### 差分

```bash
glab mr diff <iid>
glab mr diff <iid> | less -R
```

### ローカルでチェックアウトして動作確認

```bash
glab mr checkout <iid>        # 自動 fetch + switch
# … ローカルで動作・テスト …
git switch -                  # 元ブランチに戻る
```

git のリモート URL が SSH (`git@…`) でも HTTPS (`https://…`) でも動作する。HTTPS の場合は `glab auth login` で credential helper として登録された PAT が使われる。

### CI / パイプライン

```bash
glab ci status                # 現在のブランチの最新パイプライン
glab ci view                  # 対話でジョブ選択
glab ci trace                 # 失敗ジョブのログを stdout に
glab ci trace <job_id>        # 特定ジョブのログ全文
```

## 3. レビューチェックリスト

レビュー時は下記のカテゴリ観点で確認する。すべてのカテゴリが毎回該当するわけではないので、**MR の性質(コード/インフラ/DB/API/ドキュメント等)に応じて関連する項目を選んで適用**する。

### 設計・アーキテクチャ
- [ ] 設計パターン、レイヤー分離、依存関係の方向性
- [ ] スケーラビリティ・拡張性

### コード品質
- [ ] 命名規則の一貫性、単一責任原則、DRY 原則
- [ ] 可読性、適切なコメント

### 型安全性 (TypeScript 等)
- [ ] 型定義の適切性、`any` 回避、null 安全性

### エラーハンドリング
- [ ] エラーケース処理、明確なエラーメッセージ、ログ出力、リトライ

### セキュリティ
- [ ] 認証・認可、入力バリデーション、インジェクション対策
- [ ] 機密情報のハードコード回避、最小権限原則

### パフォーマンス
- [ ] N+1 問題、キャッシュ、インデックス、ページネーション

### テスト
- [ ] 単体/統合/E2E テストの適切性、網羅性

### インフラ (IaC)
- [ ] リソース名、タグ、バックアップ、モニタリング、コスト最適化

### DB 設計
- [ ] テーブル/インデックス設計、キー選択 (DynamoDB: PK/SK/GSI/LSI)

### API 設計
- [ ] RESTful/GraphQL 原則、エンドポイント設計、バージョニング、レスポンス形式

### ドキュメント
- [ ] README、API ドキュメント、設計ドキュメント整合性

### MR 全体
- [ ] 意図(タイトル/説明)が明確、関連 Issue にリンクされている
- [ ] 破壊的変更があればマイグレーション/移行手順が記述されている
- [ ] CI が緑 (`glab ci status`)
- [ ] 秘匿物 (トークン/鍵/個人情報) がコミットされていない

## 4. コメント構造とテンプレート

レビューコメントは以下のテンプレートに従う:

```markdown
### [🤖AIレビュー] [🔴必須/⚠️推奨/💡提案] タイトル

**該当**: `ファイル名:行番号`
**問題**: 問題点と理由
**推奨**: 具体的な修正案
**確認**: 設計意図の確認事項(任意)
**参考**: ドキュメントリンク(任意)

---
※このコメントはAIアシスタント(`model_name`)によって生成されています。内容には誤りが含まれる可能性があります。
```

重要度の分類:
- **🔴必須**: マージ前に修正が必要な問題
- **⚠️推奨**: 修正を推奨するが必須ではない問題
- **💡提案**: 改善案やベストプラクティスの提案

## 5. コメント投稿コマンド

通常の単発コメントは `glab mr note` で投げる:

```bash
glab mr note <iid> --message "..."     # 単発
glab mr note <iid>                     # エディタを起動して編集
```

**特定の行・行範囲に紐づく Discussion**(line-level コメント)を立てたい場合は `glab api` で discussions エンドポイントを叩く必要がある。MR 変数取得・single-line / multi-line / 削除行コメントの具体的な手順は [reference.md](reference.md) を参照。

## 6. AI レビュー運用ルール

**基本方針**:
- 指示なく `glab` コマンドでレビューコメントを投稿しない
- 「この内容でコメントして」「○○について指摘しておいて」と明示的なマージリクエストに対するコメント指示があった場合のみ、レビューコメント投稿用コマンドを生成する
- コメント投稿用コマンドを生成したら、**実行前に必ずユーザーに確認を求める**

**レビュー報告時の注意**:
- 開発者に媚びることなく、プロフェッショナルエンジニアとして学びや気づきを与えられる客観的なレビュー結果を報告する
- レビュアーが理解しやすいよう、重要な項目や指摘事項から順に報告する

**禁止事項**:
- MR の **approve / merge を自動実行しない**(レビューコメントの投稿のみ許可)
- コメントを一括投稿しない — 1件ずつ内容を確認してから投稿する
- レビュー対象外のファイル(自動生成コード、ロックファイル等)に指摘しない

## 7. 承認 / 取消 / マージ

**`approve` / `merge` は自動実行しない**。ユーザーが明示的に指示したときのみコマンドを提示し、実行はユーザーに任せる。

```bash
glab mr approve <iid>
glab mr revoke  <iid>                                    # 承認の取消
glab mr merge   <iid> --squash --remove-source-branch    # マージ
```

### よく使うマージフラグ

| フラグ | 意味 |
|---|---|
| `--squash` | コミットを 1 つに圧縮 |
| `--squash-message "..."` | squash 時のコミットメッセージ |
| `--remove-source-branch` | マージ後にソースブランチを削除 |
| `--when-pipeline-succeeds` | パイプライン成功時に自動マージ |
| `--rebase` | rebase してからマージ |

## エッジケース対応

| 状況 | 対処 |
|---|---|
| `glab` が未インストール / 未認証 | `glab auth status` で状態を確認し、未認証なら `glab auth login` を案内 |
| MR が既にマージ済み・クローズ済み | レビュー結果をテキストで報告する。コメント投稿は行わない |
| diff が巨大 (1000 行超) | 変更ファイル一覧を提示し、ユーザーにレビュー対象を絞ってもらう |
| MR 番号が不明 | `glab mr list` で直近の MR 一覧を表示し、対象を特定する |
| `mr checkout` が失敗 | 対応するリポジトリにいるか確認。git remote が SSH なら鍵登録、HTTPS なら credential helper (`glab auth git-credential`) が効いているか確認 |
| 認証エラー (401/403) | PAT の期限切れや権限不足を疑う → `docs/02-pat-setup.md` |

## ブラウザで開きたいとき

```bash
glab mr view <iid> --web      # MR ページ
glab repo view --web
glab issue view <iid> --web
```

WSL2 で `--web` を使うには `wslu` (`wslview`) が必要。`bash scripts/doctor.sh` の [10] で確認できる。

## 使用例

### 例 1: MR レビュー依頼

**入力**: 「MR !42 をレビューして」

**出力(レビュー結果報告)**:

```markdown
## MR !42 レビュー結果

### 🔴必須 (1件)

#### [🤖AIレビュー] 🔴必須 SQL インジェクションの可能性

**該当**: `backend/src/users/repository.ts:45`
**問題**: ユーザー入力がサニタイズされずにクエリに埋め込まれている
**推奨**: パラメータバインディングを使用する
**参考**: https://owasp.org/www-community/attacks/SQL_Injection

### ⚠️推奨 (1件)

#### [🤖AIレビュー] ⚠️推奨 エラーハンドリングの不足

**該当**: `backend/src/users/service.ts:78-85`
**問題**: API 呼び出しの try-catch がなく、例外が上位に伝播する
**推奨**: try-catch で囲み、適切なエラーレスポンスを返す

### 💡提案 (1件)
…(省略)

---
総括: 必須修正 1 件あり。セキュリティ修正後にマージ可能。
```

### 例 2: 特定の指摘をコメント投稿

**入力**: 「SQL インジェクションの指摘を MR !42 にコメントして」

**出力(`glab` コマンド生成 → ユーザー確認後に実行)**:

[reference.md](reference.md) の「単一行へのコメント投稿」テンプレに従って `glab api …/discussions` を組み立てる。投稿前に内容と対象行をユーザーに見せて確認を取る。

## 関連ファイル

- `reference.md` — `glab api` による discussions 投稿(MR 変数取得・single-line / multi-line / 削除行)の具体手順
- `docs/05-mr-review.md` — 人間向けのロング版手順書
- `docs/99-troubleshooting.md` — 詰まりどころ集
- `templates/vscode-tasks.json` — VS Code/Cursor から MR 操作を起動するタスク定義

## 困ったとき

- コマンドの詳細: `glab <subcommand> --help`
- 環境診断: `bash gitlab-cli-toolkit/scripts/doctor.sh`
- 認証エラー (401/403): PAT の期限切れや権限不足を疑う → `docs/02-pat-setup.md`
