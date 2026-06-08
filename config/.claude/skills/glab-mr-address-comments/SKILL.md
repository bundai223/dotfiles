---
name: glab-mr-address-comments
description: GitLab CLI (glab) で取得した MR のレビューコメント・Discussion をローカルのコード修正に反映する手順とガードレール。ユーザーが「MR のコメントに対応」「指摘を直して」「レビュー対応」「discussion を解決」「!123 のコメントを反映」などに言及したとき、または「このコメントに従って修正して」と指示したときに使用する。
---

# glab MR コメントを受けたコード修正支援

レビューで付いた Discussion / コメントを取得し、ローカルブランチで修正 → コミット → push → 必要に応じて返信/解決、までを安全に進めるための手順。
社内 Self-Managed GitLab を主想定。

## 0. 前提確認

```bash
glab auth status                  # 認証済みか
git status                        # 現在の作業状態
git rev-parse --abbrev-ref HEAD   # 現在ブランチ
```

**チェック**:
- 未認証 → `gitlab-cli-toolkit/docs/03-auth-config.md` を案内
- 未コミットの変更があるなら、まずコミット or stash する方針をユーザー確認

## 1. 対象 MR を特定する

```bash
glab mr list --reviewer=@me
glab mr list --assignee=@me
```

または現在ブランチに紐づく MR:

```bash
glab mr view -F json | jq -r '.iid'
```

ユーザー指定の `<iid>` がある場合はそれを使用。

## 2. ブランチを MR に合わせて整える

該当 MR のソースブランチをローカルにチェックアウト:

```bash
glab mr checkout <iid>
```

既にそのブランチにいる場合は最新を取得:

```bash
git pull --ff-only
```

**注意**: `git pull` が rebase 必要な状況なら、ユーザーに方針(`merge` / `rebase`)を確認する。

## 3. Discussion / コメントを取得する

### 概要を見る

```bash
glab mr view <iid> --comments -P 100
```

### 機械処理用に JSON で取得

```bash
glab mr view <iid> -F json | jq '.discussions // empty' > /tmp/discussions.json
# または
glab api "projects/$(glab repo view -F json | jq -r '.id')/merge_requests/<iid>/discussions" \
  > /tmp/discussions.json
```

### 未解決(unresolved)の Discussion を抽出

```bash
jq '[.[] | select(.notes[0].resolvable == true and .notes[-1].resolved == false)]' /tmp/discussions.json
```

各 Discussion から重要な情報:
- `notes[0].body` — 最初のコメント本文
- `notes[0].position.new_path` / `position.new_line` — 該当ファイル / 行
- `notes[0].author.username` — 投稿者
- `id` — Discussion ID(返信や resolve に使う)

## 4. 対応方針を整理してユーザー確認

取得したコメントを **重要度・該当ファイル別に整理**して提示:

```
未解決のコメント (3件):
  [1] backend/src/users/repository.ts:45  @alice
      "SQL インジェクションの可能性。パラメータバインディングに変更してください"
  [2] backend/src/users/service.ts:78-85  @bob
      "API 呼び出しに try-catch がない"
  [3] README.md:120  @carol
      "このコマンド例は古い形式です。新しい構文に更新してください"
```

**それぞれの修正方針案**を提示し、ユーザー確認を取ってから実装に入る。**コードを勝手に書き換えない**。

```
[1] への対応案:
    - prepared statement に変更 (`?` プレースホルダ + 引数配列)
    - 影響範囲: repository.ts のみ
    - テスト: 既存の users.repository.test.ts を実行

進めてよいですか?
```

## 5. ローカルで修正

ユーザーが OK したものから順に修正:

- 該当ファイルを Edit / Write で更新
- 修正後、影響範囲のテストを実行(プロジェクトの test コマンドに従う)
- lint / type check も実行(プロジェクト固有のコマンドに従う)

**ガードレール**:
- 1 コメント = 1 修正単位を意識(複数コメントの修正を 1 コミットに混ぜない)
- 関係ない箇所のリファクタリングを混ぜない
- ユーザーが指定していないコメントには触らない

## 6. コミット & push

ユーザーの明示的な指示があった場合のみ:

```bash
git add -p                                                # 変更を選んで stage(自動で git add -A しない)
git commit -m "fix: address review comment on <topic>"
git push
```

**コミットメッセージの方針**:
- レビュー対応であることが分かる接頭辞(例: `review:` / `fix(review):` / `chore(review):`)
- 関連 Discussion ID やコメント要約を本文に含めると追跡しやすい

## 7. Discussion に返信 / 解決

### 返信(明示指示時のみ)

```bash
DISCUSSION_ID="<取得した id>"
glab api "projects/${PROJECT_ID}/merge_requests/<iid>/discussions/${DISCUSSION_ID}/notes" \
  -X POST --field "body=対応しました。コミット <sha> で修正しています。"
```

### 解決マーク(resolve)

```bash
glab api "projects/${PROJECT_ID}/merge_requests/<iid>/discussions/${DISCUSSION_ID}" \
  -X PUT --field "resolved=true"
```

**運用上の推奨**: resolve は**コメントした本人がするのが望ましい**。AI 経由で resolve は基本行わず、ユーザーが「resolve まで」と明示した時のみ実行。

## 8. CI 確認

push 後にパイプラインの結果を見る:

```bash
glab ci status
glab ci view                # 失敗ジョブを選んで確認
glab ci trace <job_id>      # ログを取得
```

CI 落ちたら原因を特定して再修正(同じフローを繰り返す)。

## 運用ルール (AI 主導で MR 修正対応するときのガードレール)

**基本方針**:
- コメントを取得・整理した後、**修正方針をユーザーに提示し、明示的な OK を得てから**コードを書き換える
- `git add` / `git commit` / `git push` は明示指示があった時にだけ実行する
- Discussion の返信・resolve は**慎重**に。「対応した」と書く前に、本当に対応したか自分で diff を見て確認

**禁止事項**:
- ユーザー未確認のまま自動でコード修正・コミット・push しない
- 関係ないコメント(質問のみ・既に対応済み・別途タスク化されているもの)に勝手に対応しない
- AI のレビュー判断で「このコメントは無視してよい」と勝手に判断しない(ユーザー確認必須)
- 自分で MR を approve / merge しない
- レビュアーに無断で **resolve した状態のまま push** しない

## エッジケース対応

| 状況 | 対処 |
|---|---|
| MR が既にマージ済み | 警告し、必要なら新規 MR / 別ブランチでの修正を提案 |
| 該当行が既に変更されている(古いコメント) | ユーザーに事実を伝え、対応するか判断を仰ぐ |
| 同じファイルに複数の競合する指摘 | 整理して提示し、優先度や設計意図をユーザーに確認 |
| コメントが質問・確認のみ(コード修正不要) | 修正せず、返信ドラフトをユーザーに提示する |
| Discussion 件数が多すぎる | 重要度や該当ファイル別にグルーピングして提示、対応する範囲を絞ってもらう |
| `mr checkout` が失敗 | git remote(SSH/HTTPS)と認証を確認 → `docs/99-troubleshooting.md` |

## 使用例

### 例 1: コメント全体への対応

**入力**: 「!42 のレビューコメントに従って修正して」

**手順**:
1. `glab mr checkout 42` でブランチ切替
2. `glab mr view 42 --comments -P 100` で全体把握
3. 未解決 Discussion を抽出 → 整理してユーザーに提示
4. 各コメントに対する修正方針案を提示 → ユーザー確認
5. 同意した範囲のみ修正 → diff を見せる
6. ユーザー確認後にコミット&push のコマンドを提示
7. push 後の CI 状況を `glab ci status` で報告

### 例 2: 特定コメントだけに対応

**入力**: 「@alice のセキュリティ指摘だけ対応して、他は触らないで」

**ポイント**:
- 投稿者でフィルタ: `jq '[.discussions[].notes[] | select(.author.username=="alice")]'`
- 該当 Discussion のみ修正案を提示、他には触れない
- コミットメッセージにも対応範囲を明記

## 関連ファイル

- [skills/glab-mr-review/SKILL.md](../glab-mr-review/SKILL.md) — レビュー(コメント投稿)側の手順
- [skills/glab-mr-review/reference.md](../glab-mr-review/reference.md) — line-level コメント / Discussion API の詳細
- [skills/glab-mr-create/SKILL.md](../glab-mr-create/SKILL.md) — MR 作成側の手順
- [docs/05-mr-review.md](../../docs/05-mr-review.md) — MR 全般の解説

## 困ったとき

- コマンド詳細: `glab mr --help`、`glab api --help`
- 環境診断: `bash gitlab-cli-toolkit/scripts/doctor.sh`
- 認証エラー: PAT 期限切れ / スコープ不足 → `docs/02-pat-setup.md`
- push 失敗(HTTPS): credential helper の有無を確認 → `docs/99-troubleshooting.md`
