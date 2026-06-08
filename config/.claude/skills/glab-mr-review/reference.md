# glab レビューコメント投稿リファレンス

`glab mr note` ではできない **特定の行・行範囲に紐づく Discussion**(line-level コメント)を、`glab api` で discussions エンドポイントを直接叩いて投稿する手順をまとめる。

## 前提: MR 変数の取得

レビューコメント投稿には以下の変数が必要。MR 情報取得時に設定する:

```bash
eval $(glab mr view <MR番号> -F json | jq -r '
  "PROJECT_ID=\(.project_id) " +
  "SOURCE_BRANCH=\(.source_branch) " +
  "TARGET_BRANCH=\(.target_branch) " +
  "BASE_SHA=\(.diff_refs.base_sha) " +
  "HEAD_SHA=\(.diff_refs.head_sha) " +
  "START_SHA=\(.diff_refs.start_sha) " +
')
```

| 変数 | 説明 |
|---|---|
| `PROJECT_ID` | GitLab プロジェクトID |
| `SOURCE_BRANCH` | MR のソースブランチ名 |
| `TARGET_BRANCH` | MR のターゲットブランチ名 |
| `BASE_SHA` | diff の base SHA |
| `HEAD_SHA` | diff の head SHA |
| `START_SHA` | diff の start SHA |

## 単一行へのコメント投稿

```bash
COMMENT="レビューコメント内容"
FILE_PATH="対象ファイルのパス"   # 例: "frontend/src/components/Example.tsx"
LINE_NO=10                       # コメント対象の行番号

glab api "projects/${PROJECT_ID}/merge_requests/<MR番号>/discussions" \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --input - <<EOF
body=${COMMENT}&\
type=DiffNote&\
position[position_type]=text&\
position[base_sha]=${BASE_SHA}&\
position[head_sha]=${HEAD_SHA}&\
position[start_sha]=${START_SHA}&\
position[new_path]=${FILE_PATH}&\
position[old_path]=${FILE_PATH}&\
position[new_line]=${LINE_NO}
EOF
```

## 複数行へのコメント投稿(line_range 指定)

```bash
COMMENT="レビューコメント内容"
FILE_PATH="対象ファイルのパス"
START_LINE=10   # コメント範囲の開始行
END_LINE=20     # コメント範囲の終了行
FILE_SHA=$(echo -n "${FILE_PATH}" | sha1sum | cut -d' ' -f1)

glab api "projects/${PROJECT_ID}/merge_requests/<MR番号>/discussions" \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --input - <<EOF
body=${COMMENT}&\
type=DiffNote&\
position[position_type]=text&\
position[base_sha]=${BASE_SHA}&\
position[head_sha]=${HEAD_SHA}&\
position[start_sha]=${START_SHA}&\
position[new_path]=${FILE_PATH}&\
position[old_path]=${FILE_PATH}&\
position[new_line]=${END_LINE}&\
position[line_range][start][type]=new&\
position[line_range][start][new_line]=${START_LINE}&\
position[line_range][start][line_code]=${FILE_SHA}_0_${START_LINE}&\
position[line_range][end][type]=new&\
position[line_range][end][new_line]=${END_LINE}&\
position[line_range][end][line_code]=${FILE_SHA}_0_${END_LINE}
EOF
```

## 注意事項

- `position[new_line]` は追加・変更された行に使用する
- 削除された行にコメントする場合は `position[old_line]` を使用し、`position[new_line]` は省略する
- `old_path` はファイル名が変更されていない場合でも必須(`new_path` と同じ値を指定)
- `type=DiffNote` は diff 行に紐づく Discussion を作成する。MR 全体への一般コメントは `glab mr note` を使う
- 本文に `&` `=` などのシェル解釈で問題が出る文字を含む場合はエンコード or `--input` で個別フィールドに分けて投げる

## 参考コマンド

```bash
# MR 基本操作
glab mr list
glab mr view <MR番号>
glab mr diff <MR番号>
glab mr view <MR番号> --comments -P 100        # 既存コメントも含めて表示

# MR 情報を JSON で取得 (jq でフィールド抽出可)
glab mr view <MR番号> -F json | jq .
glab mr view <MR番号> -F json | jq -r '.source_branch'

# 既存の Discussion 一覧を取得
glab api "projects/${PROJECT_ID}/merge_requests/<MR番号>/discussions" | jq .
```
