include_cookbook 'ruby'
include_cookbook 'python'
include_cookbook 'yarn'
include_cookbook 'ghq'

package 'cmake'

# ruby
# gem_package 'neovim'
execute 'gem install --user-install neovim' do
  user node[:user]
  command <<-EOCMD
  . /etc/profile.d/asdf.sh
  gem install --user-install neovim
  EOCMD
end

# pip =
%w[
  neovim
  neovim-remote
].each do |pip|
  # cmds =
  %w[
    pip pip
  ].each do |pipcmd|
    execute "#{pipcmd} install --upgrade --user #{pip}" do
      user node[:user]

      command <<-EOCMD
        . /etc/profile.d/asdf.sh
        #{pipcmd} install --upgrade --user #{pip}
      EOCMD
      only_if ". /etc/profile.d/asdf.sh; which #{pipcmd}"
    end
  end
end

# pip3
%w[
  neovim-remote
].each do |pip|
  # cmds =
  execute "pip3 install --upgrade --user #{pip}" do
    user node[:user]
    only_if 'which pip3'
  end
end

# Node.js
execute 'yarn global add neovim' do
  user node[:user]
  command <<-EOCMD
    . /etc/profile.d/asdf.sh
    yarn global add neovim
  EOCMD
end

# include_cookbook 'perl'
# execute 'cpanm Neovim::Ext'

# go_get 'github.com/tennashi/vimalter'
execute 'install vimalter' do
  command <<-EOCMD
    mkdir work_vimalter
    cd work_vimalter
    wget https://github.com/tennashi/vimalter/releases/download/0.1.0/vimalter_0.1.0_Linux_64-bit.tar.gz -O vimalter.tar.gz
    tar xfz  vimalter.tar.gz
    mv vimalter ~/.local/bin
    cd ..
    rm -rf work_vimalter
  EOCMD
  user node[:user]
  not_if 'test -f ~/.local/bin/vimalter'
end

# if arch package 'fd'
package 'fd-find'
execute 'ln -s $(which fdfind) ~/.local/bin/fd' do
  user node[:user]
  not_if 'test -f ~/.local/bin/fd'
end
