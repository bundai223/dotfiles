include_recipe 'recipe_helper'

user = ENV['SUDO_USER'] || ENV['USER']
home = %x[cat /etc/passwd | grep #{user} | awk -F: '!/nologin/{print $(NF-1)}'].strip

node.reverse_merge!(
  user: user,
  home: home
)


include_role node[:platform]
