
directory "#{node[:home]}/.config" do
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
end

remote_file "#{node[:home]}/.config/nvim/init.vim" do
  source 'files/init.vim'
  owner node[:user]
  group node[:user]
end

remote_file "#{node[:home]}/.zshrc" do
  source 'files/.zshrc'
  owner node[:user]
  group node[:user]
end

remote_file "#{node[:home]}/.zshenv" do
  source 'files/.zshenv'
  owner node[:user]
  group node[:user]
end

remote_file "#{node[:home]}/.tmux.conf" do
  source 'files/.tmux.conf'
  owner node[:user]
  group node[:user]
end
