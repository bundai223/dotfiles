# include_recipe './dependency.rb'
include_cookbook './asdf'

# node.reverse_merge!({
#   lua: {
#     version: '10.13.0',
#   }
# })

version = 'latest'
version = node[:lua][:version] unless node[:lua].nil?
user = node[:user]
home = node[:home]

execute 'install asdf-lua' do
  user user
  command <<-EOCMD
    source /etc/profile.d/asdf.sh
    asdf plugin-add lua
  EOCMD
  not_if "test -d #{home}/.asdf/plugins/lua"
end

[
  { cmd: 'asdf plugin add lua', not_if: 'asdf plugin list | grep lua' },
  { cmd: "asdf install lua #{version}", not_if: "asdf list lua | grep #{version}" },
  { cmd: "asdf global lua #{version}" },
  { cmd: 'asdf reshim lua' }
].each do |op|
  source_asdf_and_execute op[:cmd] do
    user user
    not_if_ op[:not_if] unless op[:not_if].nil?
  end
end
