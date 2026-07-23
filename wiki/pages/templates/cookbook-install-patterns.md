---
title: cookbookのツール導入パターン（バージョン固定 vs 自動更新任せ）
genre: templates
summary: バイナリ配布のみのツールはバージョン固定で導入、自動更新機構を持つツールは固定せず未導入時のみ入れる。
updated: 2026-07-23
confidence: high
status: active
sources:
  - raw/conversations/2026-07-23_herdr導入とllm-wiki導入.md
---

# cookbookのツール導入パターン

ツールが自前の更新機構を持つかどうかで2パターンを使い分ける。

## パターンA: バージョン固定（更新機構を持たないツール）

例: gitleaks, lefthook。冒頭で `version` を宣言し、アップグレードはその書き換えで行う。

- 単一バイナリ配布なら `get_bin_github_release` ヘルパー（`lib/recipe_helper.rb`）を使う
  （/usr/local/bin へ配置、`version_cmd` の出力一致で冪等化）
- tar.gz配布なら `execute` + `not_if "<tool> version | grep -q '#{version}'"`

## パターンB: 自動更新任せ（自己更新機構を持つツール）

例: herdr（`herdr update` / `herdr channel set`）。

- cookbookでバージョンを固定**しない**。固定すると自己更新と競合する
- 公式インストールスクリプトを `execute` + `not_if '未導入チェック'` で「無ければ入れる」だけにする
- 配置先が `~/.local/bin` の場合、not_ifは `test -x ~/.local/bin/<tool> || command -v <tool>`
  （非対話shはPATHに~/.local/binを含まないことがあるためパス直指定を先に）

## 共通

- macOSは原則 `package '<tool>'`（homebrew）
- 直近の慣例ではrolesへの登録は必須ではない（gitleaks / lefthook / herdrは未登録。`bin/deploy` で個別適用）
