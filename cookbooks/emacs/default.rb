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

execute 'ln -s ~/repos/github.com/syl20bnr/spacemacs ~/.emacs.d' do
  user node[:user]
  not_if 'test -e ~/.emacs.d'
end

# spacemacs-japanese
execute 'ln -s ~/repos/github.com/kenjimyzk/spacemacs-japanese ~/.config/spacemacs/layers/japanese' do
  user node[:user]
  not_if 'test -L ~/.config/spacemacs/layers/japanese'
end

file "#{node[:home]}/.aspell.conf" do
  action :create
  owner node[:user]
  group node[:group]

  content "lang en_US"
end
