include_cookbook 'dotfiles'
include_cookbook 'ghq'
include_cookbook 'uv'

repos = %w[
  dylanaraps/neofetch
  mzyy94/RictyDiminished-for-Powerline
  rupa/z
  yuru7/HackGen
  zsh-users/zsh-completions
  zplug/zplug
  zk-phi/sky-color-clock
]
repos.each { |name| get_repo name }

uv = "PATH=#{node[:home]}/.local/bin:$PATH uv"

execute 'uv tool install powerline-status' do
  user node[:user]
  command "#{uv} tool install powerline-status --with powerline-gitstatus"
  not_if 'PATH=~/.local/bin:$PATH which powerline'
end

execute 'uv tool install python-language-server' do
  user node[:user]
  command "#{uv} tool install python-language-server"
  not_if 'PATH=~/.local/bin:$PATH which pyls'
end

{
  'yamllint' => 'yamllint',
  'cfn-lint' => 'cfn-lint',
  'vim-vint' => 'vint',
}.each do |pkg, executable|
  execute "uv tool install #{pkg}" do
    user node[:user]
    command "#{uv} tool install #{pkg}"
    not_if "PATH=~/.local/bin:$PATH which #{executable}"
  end
end

package 'fontforge'
