case node[:platform]
when 'debian', 'ubuntu', 'mint'
  include_cookbook 'aspell'

  package 'emacs'
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'arch'
  include_cookbook 'yay'
  include_cookbook 'aspell'
  yay 'cmigemo'

  package 'emacs'
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
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
