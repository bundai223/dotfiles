include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  execute 'sed -i.bk /etc/locale.gen -e "s/#ja_JP.UTF-8/ja_JP.UTF-8/g"'
  execute 'locale-gen'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
