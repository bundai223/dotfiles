include_recipe 'dependency.rb'

user = node[:user]
home = node[:home]

execute "git clone https://github.com/asdf-vm/asdf.git #{home}/.asdf" do
  user user
  not_if "test -f #{home}/.asdf"
end

file "/etc/profile.d/asdf.sh" do
  content "source #{home}/.asdf/asdf.sh"
  not_if "test -e /etc/profile.d/asdf.sh"
  mode '644'
end
