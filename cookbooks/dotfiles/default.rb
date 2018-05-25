
directory "#{node[:home]}/.config" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.local/bin" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.config/git" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.config/zsh/z" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/.config/nvim" do
  owner node[:user]
  group node[:group]
end

directory "#{node[:home]}/repos" do
  owner node[:user]
  group node[:group]
end

remote_file "#{node[:home]}/.gitconfig" do
  source 'files/.gitconfig'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.gitconfig"
end

template "#{node[:home]}/.config/nvim/init.vim" do
  source 'templates/init.vim.erb'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.config/nvim/init.vim"
end

template "#{node[:home]}/.zshrc" do
  source 'templates/.zshrc.erb'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.zshrc"
end

template "#{node[:home]}/.zshenv" do
  source 'templates/.zshenv.erb'
  owner node[:user]
  group node[:group]
  not_if "test -e #{node[:home]}/.zshenv"
end

remote_file "#{node[:home]}/.tmux.conf" do
  source 'files/.tmux.conf'
  owner node[:user]
  group node[:group]
end

remote_file "#{node[:home]}/.ctags" do
  source '../../config/.ctags'
  owner node[:user]
  group node[:group]
end

#dotfile '.config/powerline'
execute "ln -s #{node[:home]}/repos/github.com/bundai223/dotfiles/config/.config/powerline #{node[:home]}/.config/powerline" do
  not_if "test -e #{node[:home]}/.config/powerline"
end
