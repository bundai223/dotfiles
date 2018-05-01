
directory "#{node[:home]}/.config" do
  owner node[:user]
  group node[:user]
end


directory "#{node[:home]}/.config/zsh/z" do
  owner node[:user]
  group node[:user]
end

directory "#{node[:home]}/.config/nvim" do
  owner node[:user]
  group node[:user]
end

directory "#{node[:home]}/repos" do
  owner node[:user]
  group node[:user]
end

#ln '.gitconfig'
remote_file "#{node[:home]}/.gitconfig" do
  source 'files/.gitconfig'
  owner node[:user]
  group node[:user]
  not_if "test -e #{node[:home]}/.gitconfig"
end

template "#{node[:home]}/.config/nvim/init.vim" do
  source 'templates/init.vim.erb'
  owner node[:user]
  group node[:user]
  not_if "test -e #{node[:home]}/.config/nvim/init.vim"
end

template "#{node[:home]}/.zshrc" do
  source 'templates/.zshrc.erb'
  owner node[:user]
  group node[:user]
  not_if "test -e #{node[:home]}/.zshrc"
end

template "#{node[:home]}/.zshenv" do
  source 'templates/.zshenv.erb'
  owner node[:user]
  group node[:user]
  not_if "test -e #{node[:home]}/.zshenv"
end

ln '.tmux.conf'
#remote_file "#{node[:home]}/.tmux.conf" do
#  source 'files/.tmux.conf'
#  owner node[:user]
#  group node[:user]
#end
