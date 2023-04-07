node.reverse_merge!({
#  mysql: {
#    root_password: 'D12uM3m4y+',
#  }
})

include_cookbook 'sudo_nopassword'
include_cookbook 'dotfiles'
include_cookbook 'git'
include_cookbook 'perl'
# include_cookbook 'perl' if not %w(ubuntu debian).include?(node[:platform])
include_cookbook 'ruby' # git hookスクリプトで必要なので先にインストールする'
include_cookbook 'go'
include_cookbook 'ghq'
include_cookbook 'python'
include_cookbook 'nodejs'
include_cookbook 'yarn'
include_cookbook 'rust'

# include_cookbook 'tmux'
include_cookbook 'neovim'
include_cookbook 'zsh'
# include_cookbook 'mysql'
include_cookbook 'zeroconf'
# include_cookbook 'chrome'

include_cookbook 'myrepos'
include_cookbook 'fonts'
include_cookbook 'favorite_repos'
