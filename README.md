# dotfiles

itamae/mitamaeで開発環境を構築するためのレシピと、そのレシピから配置される設定ファイルを管理するリポジトリです。

Linux、macOS、Windows向けのセットアップを含みます。Linux/macOSでは`install`、`bin/setup`、`bin/deploy`を経由してmitamaeを実行し、`roles/`と`cookbooks/`配下のレシピでパッケージのインストールやdotfilesの配置を行います。WindowsではPowerShellスクリプトでScoopアプリや設定ファイルのシンボリックリンクを配置します。

## Repository layout

- `install`: Linux/macOS向けの入口スクリプトです。リポジトリを`~/work_dotfile`へ取得し、`bin/setup`と`bin/deploy`を実行します。
- `bin/setup`: mitamaeバイナリを`bin/mitamae`へダウンロードします。
- `bin/deploy`: mitamaeを実行します。引数なしの場合は現在のプラットフォームに対応するrole全体を適用し、引数ありの場合は指定したcookbookだけを適用します。
- `lib/recipe.rb`: `node[:platform]`に応じて`roles/<platform>/default.rb`を読み込みます。
- `lib/recipe_helper.rb`: レシピ内で使うヘルパー、nodeの初期値、dotfile配置用の定義をまとめています。
- `roles/`: OSやディストリビューション単位の構成です。`base` roleと各OS固有のcookbookを組み合わせます。
- `cookbooks/`: パッケージ、ツール、設定ごとのitamae/mitamaeレシピです。
- `config/`: ホームディレクトリや各アプリケーション設定として配置される設定ファイル群です。
- `install.ps1`: Windows向けの入口スクリプトです。WSL2有効化、Scoopアプリの導入、設定ファイルのシンボリックリンク作成を行います。

## How to install

### Linux

```sh
curl https://raw.githubusercontent.com/bundai223/dotfiles/main/install | bash -s
```

### For Windows

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb https://raw.githubusercontent.com/bundai223/dotfiles/main/install.ps1 | iex
```

## How to deploy

既にリポジトリをclone済みの場合は、リポジトリルートで以下を実行します。

```sh
bin/deploy
```

引数なしの`bin/deploy`は、`lib/recipe.rb`から現在のプラットフォームに対応するroleを適用します。例えばUbuntuでは`roles/ubuntu/default.rb`が読み込まれ、さらに`roles/base/default.rb`や各cookbookが適用されます。

特定のcookbookだけ適用したい場合は、cookbook名またはパスを指定します。

```sh
bin/deploy cookbooks/git
bin/deploy cookbooks/zsh/default.rb
```

`bin/deploy`はmacOSでは通常ユーザーでmitamaeを実行し、それ以外の環境では`sudo`経由で実行します。

## Config placement

`config/`配下のファイルは、`cookbooks/dotfiles/default.rb`やWindowsの`install.ps1`からホームディレクトリ配下へ配置されます。Linux/macOSでは主に`~/.config`や`~`直下へシンボリックリンクを作成し、必要なディレクトリや初期ファイルもあわせて作成します。

例:

- `config/.gitconfig` -> `~/.gitconfig`
- `config/.config/nvim` -> `~/.config/nvim`
- `config/.config/wezterm` -> `~/.config/wezterm`
- `config/zsh` -> zsh関連設定から参照
- `config/WindowsTerminal/settings.json` -> Windows Terminal設定

## Development notes

新しい環境構築処理を追加する場合は、原則として`cookbooks/<name>/default.rb`を追加し、必要に応じて`dependency.rb`を分けます。標準環境に含めたい場合は`roles/base/default.rb`または対象OSのroleから`include_cookbook '<name>'`で読み込んでください。

## For Developer.

### Windows install script is old. Is `install.ps1` cached?

Yes. Try to use this scripts.

```powershell
iwr -Headers @{"Cache-Control"="no-cache"} -useb https://raw.githubusercontent.com/bundai223/dotfiles/main/install.ps1 | iex
```
