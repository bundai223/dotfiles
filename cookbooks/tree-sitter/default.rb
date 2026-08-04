include_recipe 'dependency.rb'
include_cookbook './rust'

# tree-sitter CLI。nvim-treesitter (mainブランチ) がパーサのコンパイルに使う。
# 要求される最小バージョンは nvim-treesitter の
# lua/nvim-treesitter/health.lua にある TREE_SITTER_MIN_VER を参照する。
#
# 以前は cookbooks/rust の .default-cargo-crates に混ぜて入れていたが、
# nvim-treesitter が要求するバージョンを明示したいので専用cookbookへ切り出した。
#
# 公式READMEは `cargo binstall tree-sitter-cli` を案内しているが、
# binstallが取得するprebuiltバイナリは GLIBC 2.39 を要求するため
# Ubuntu 22.04 (GLIBC 2.35) では実行できない。ここではソースビルドする。
#
# アップグレードしたいときはこのバージョンを更新する。
# リリース一覧: https://github.com/tree-sitter/tree-sitter/releases
target_name = 'tree-sitter'
version = '0.26.11'
user = node[:user]
home = node[:home]

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  # asdfのrust shimが /usr/local/bin より先にPATHへ入るため、
  # asdfのbin配下ではなく ~/.local/bin へ入れて配置場所を固定する。
  # --force は別バージョンが既にある場合の上書き用。実行要否はnot_ifで判定するので
  # 毎回ビルドし直すことはない。
  source_asdf_and_execute "cargo install --locked --force --root #{home}/.local #{target_name}-cli --version #{version}" do
    user user

    # 非対話shではPATHに ~/.local/bin が入らないことがあるのでパスを直接指定する。
    not_if_ "test -x #{home}/.local/bin/#{target_name} && #{home}/.local/bin/#{target_name} --version 2>/dev/null | grep -q '#{version}'"
  end
when 'osx', 'darwin'
  # macOSはhomebrewで入れる。
  package 'tree-sitter'
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
