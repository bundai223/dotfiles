include_cookbook 'ruby'
include_cookbook 'python'
include_cookbook 'uv'
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

neovim_python = "#{node[:home]}/.local/share/venvs/neovim"
uv = "PATH=#{node[:home]}/.local/bin:$PATH uv"

directory "#{node[:home]}/.local/share" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.local/share/venvs" do
  owner node[:user]
  group node[:group]
end

execute 'install neovim python provider' do
  user node[:user]
  command <<-EOCMD
    . /etc/profile.d/asdf.sh
    #{uv} venv #{neovim_python}
    #{uv} pip install --python #{neovim_python}/bin/python pynvim neovim-remote
  EOCMD
  not_if "test -x #{neovim_python}/bin/python && #{neovim_python}/bin/python -c 'import pynvim'"
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

case node[:platform]
when 'arch'
when 'osx', 'darwin'
  package "fd"
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  # if arch package 'fd'
  package 'fd-find'
  execute 'ln -s $(which fdfind) ~/.local/bin/fd' do
    user node[:user]
    not_if 'test -f ~/.local/bin/fd'
  end
when 'opensuse'
else
end
