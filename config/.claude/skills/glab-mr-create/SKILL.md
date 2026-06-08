---
name: glab-mr-create
description: GitLab CLI (glab) で現在のブランチからマージリクエスト(MR)を作成する手順とガードレール。ユーザーが「MR を作って」「マージリクエスト出して」「PR 作成」「draft で MR」「reviewer に X さんを指定して MR」などに言及したとき、または「これを MR にして」と現在の作業を MR にする意図を示したときに使用する。
---

# glab を使った MR 作成支援

GitLab CLI (`glab`) で**現在のローカルブランチを元に MR を作成する**ための手順と、安全に作るためのガードレール。
社内 Self-Managed GitLab (`gitlab-system-dev.k-idea.jp` など) を主想定。git プロトコルは SSH / HTTPS のどちらでも動作する。

## 0. 前提確認

```bash
glab auth status                  # 認証済みか
git status                        # 未コミット変更がないか
git log --oneline -5              # 直近のコミット内容
git rev-parse --abbrev-ref HEAD   # 現在ブランチ
git remote -v                     # 対象リポジトリが正しいか
```

**チェック**:
- 未認証 → `gitlab-cli-toolkit/docs/03-auth-config.md` の手順を案内
- 未コミットの変更があるなら、コミット or stash するかをユーザーに確認(勝手にコミットしない)
- main / master / production ブランチに直接いる場合は、専用ブランチを切ることをユーザーに提案

## 1. ターゲットブランチを決める

プロジェクトのデフォルトブランチを取得して、明示指定がなければそれを使う:

```bash
glab repo view -F json | jq -r '.default_branch'
```

ユーザーが target branch を指定している場合(例: `release/x.y` 向けの hotfix)はそちらを優先する。

## 2. プッシュと差分プレビュー

```bash
# まだ push していないブランチなら push
git push -u origin "$(git rev-parse --abbrev-ref HEAD)"

# ターゲットとの差分を要約
TARGET=main   # 上記で取得した値
git log --oneline "${TARGET}..HEAD"
git diff "${TARGET}...HEAD" --stat
```

**ガードレール**:
- 既に同じソースブランチで MR が存在する場合は新規作成しない(既存 MR を確認):

  ```bash
  glab mr list --source-branch "$(git rev-parse --abbrev-ref HEAD)"
  ```
- 差分が空 / コミットが target に含まれている場合は MR 作成を中止し、ブランチ運用の見直しをユーザーに伝える

## 3. タイトル・description の組み立て

### タイトル
- ブランチ名・コミットメッセージから初期案を提示し、ユーザー確認を取る
- 慣習に応じて prefix を付ける(`feat:` `fix:` `chore:` `docs:` …。プロジェクトの方針に従う)

### description テンプレート

`.gitlab/merge_request_templates/*.md` がリポジトリにあれば自動で読み込まれる。テンプレが無い場合の最小構成:

```markdown
## 概要
(この MR が何をするか、なぜ必要かを 2-3 行で)

## 変更内容
- (主な変更点を箇条書き)

## 動作確認
- [ ] (確認した手順)

## 関連
- 関連 Issue / 仕様: !... or #...
```

description はエディタで編集(`glab` の editor 設定に従う)するのが基本。短文なら `--description` 直指定でも可。

## 4. `glab mr create` のフラグ組み立て

```bash
glab mr create \
  --title "<タイトル>" \
  --description "<本文 or @<file>>" \
  --target-branch "${TARGET}" \
  --source-branch "$(git rev-parse --abbrev-ref HEAD)" \
  --reviewer "@user1,@user2" \
  --assignee  "@me" \
  --label    "needs-review,backend" \
  --draft \
  --remove-source-branch \
  --squash-before-merge
```

### よく使うフラグ

| フラグ | 用途 |
|---|---|
| `--title` / `-t` | タイトル |
| `--description` / `-d` | 本文(`-d "@path/to/file.md"` で外部ファイル可) |
| `--target-branch` / `-b` | マージ先 |
| `--source-branch` / `-s` | ソース(省略時は現在ブランチ) |
| `--reviewer` | reviewer ユーザー名(`@me` も可、複数はカンマ区切り) |
| `--assignee` | assignee |
| `--label` | ラベル(複数はカンマ区切り) |
| `--milestone` | マイルストーン |
| `--draft` | ドラフトとして作成(レビュー早期共有時) |
| `--remove-source-branch` | マージ時にソースブランチ削除 |
| `--squash-before-merge` | squash でマージ |
| `--yes` | 確認プロンプトをスキップ(**自動化時のみ。通常は使わない**) |

### 推奨方針

- **デフォルトは `--draft`** で作成し、レビュー準備が整ったら `glab mr update <iid> --ready` で外す
- **reviewer を必ず指定**(空 MR は埋もれる)。明示指定がなければ CODEOWNERS や直近の MR から推測 → ユーザー確認
- **`--yes` は使わない**。`glab mr create` は実行前に内容を表示するので、ユーザーに確認を取って実行

## 5. 実行前のユーザー確認

コマンドを生成したら、**実行前に必ずユーザーに以下を提示**:

- タイトル / description プレビュー
- target / source ブランチ
- reviewer / assignee / label
- draft かどうか

「この内容で作成してよいですか?」と確認してから実行する。

## 6. 作成後

- 結果として MR の URL が出力される。コピーして関係者に共有
- CI が自動で走る場合は `glab ci status` で進行確認
- description にチェックリストがある場合、後続で UI から更新

## 運用ルール (AI 主導で MR 作成するときのガードレール)

**基本方針**:
- 指示なく `git commit` / `git push` / `glab mr create` を**自動実行しない**
- ユーザーが明示的に「MR を作って」と言ったときに、**コマンドを生成してユーザー確認後に実行**する

**禁止事項**:
- 未コミットの差分を勝手にコミットしない
- main / master 向けの直接 push をしない
- `--yes` フラグを既定で付けない
- 過去のレビュアーパターンや CODEOWNERS から reviewer を**推測したら必ずユーザー確認**を取る(勝手に @-mention しない)
- 自分で MR を approve しない / merge しない

## エッジケース対応

| 状況 | 対処 |
|---|---|
| 未コミット変更がある | コミット or stash の方針をユーザーに確認。勝手にコミットしない |
| 同じ source branch の opened MR が既に存在 | 新規作成せず既存 MR の URL を案内 |
| ブランチがまだ push されていない | `git push -u origin <branch>` を提案 |
| target branch が不明 | `glab repo view -F json \| jq -r '.default_branch'` で確認、ユーザーに提示 |
| description テンプレが無い | 上記の最小テンプレを提示 |
| reviewer 指定がない | 「reviewer は誰にしますか?」と確認(推測したら必ず確認) |
| MR テンプレが複数ある | `--template <name>` で明示。テンプレ一覧を提示してユーザーに選んでもらう |

## 使用例

### 例 1: 通常の draft MR 作成

**入力**: 「現在のブランチで draft MR 作って、reviewer は @alice」

**手順**:
1. `glab auth status` / `git status` / 現在ブランチ確認
2. target branch を `glab repo view -F json` から取得
3. `git log --oneline TARGET..HEAD` の差分要約をユーザーに提示
4. タイトル・description 案を提示してユーザー確認
5. 以下のコマンドを提示してユーザー確認後に実行:

   ```bash
   git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
   glab mr create \
     --title "feat: ..." \
     --description "@.gitlab/merge_request_templates/default.md" \
     --target-branch main \
     --reviewer @alice \
     --assignee @me \
     --draft \
     --remove-source-branch \
     --squash-before-merge
   ```
6. URL を報告

### 例 2: hotfix を release ブランチ向けに

**入力**: 「これを release/2.4 向けの hotfix MR にして、Title は 'fix: 〇〇'」

**ポイント**:
- `--target-branch release/2.4` を明示
- ラベルに `hotfix` を付ける(プロジェクト運用に応じて)
- draft では出さない(緊急 MR の場合)

## 関連ファイル

- [skills/glab-mr-review/SKILL.md](../glab-mr-review/SKILL.md) — レビュー側の手順
- [docs/05-mr-review.md](../../docs/05-mr-review.md) — MR 全般の解説
- [docs/04-vscode-cursor.md](../../docs/04-vscode-cursor.md) — エディタ統合(description 編集)

## 困ったとき

- コマンド詳細: `glab mr create --help`
- 環境診断: `bash gitlab-cli-toolkit/scripts/doctor.sh`
- 認証エラー (401/403): PAT の期限切れ / スコープ不足を疑う → `docs/02-pat-setup.md`
- push が失敗(HTTPS): credential helper(`glab auth git-credential`)が効いているか確認 → `docs/99-troubleshooting.md`
