case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'aspell'
  package 'aspell-en'

  package 'emacs'
when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
when 'arch'
  include_cookbook 'yay'
  package 'aspell'
  package 'aspell-en'
  yay 'cmigemo'

  package 'emacs'
when 'opensuse'
else
end

get_repo 'kenjimyzk/spacemacs-japanese'
get_repo 'syl20bnr/spacemacs'

execute "ln -s #{node[:home]}/repos/github.com/syl20bnr/spacemacs #{node[:home]}/.emacs.d" do
  not_if "test -e #{node[:home]}/.emacs.d"
end

# spacemacs-japanese
execute run_as(node[:user], "ln -s #{node[:home]}/repos/github.com/kenjimyzk/spacemacs-japanese #{node[:home]}/.config/spacemacs/layers/japanese") do
  not_if "test -L #{node[:home]}/.config/spacemacs/layers/japanese"
end

file "#{node[:home]}/.aspell.conf" do
  action :create
  owner node[:user]
  group node[:group]

  content "lang en_US"
end
