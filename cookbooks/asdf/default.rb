include_recipe 'dependency.rb'

user = node[:user]

execute 'git clone https://github.com/asdf-vm/asdf.git ~/.asdf' do
  user user
end

case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end

