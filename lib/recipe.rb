include_recipe 'recipe_helper'

user = ENV['SUDO_USER'] || ENV['USER']
case node[:platform]
when 'osx', 'darwin'
  home = ENV['HOME']
  group = 'staff'
else
  home = %x[cat /etc/passwd | grep #{user} | awk -F: '!/nologin/{print $(NF-1)}'].strip
  group = user
end

node.reverse_merge!(
  user: user,
  group: group,
  home: home
)


include_role node[:platform]
