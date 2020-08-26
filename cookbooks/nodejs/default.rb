include_recipe './dependency.rb'

# node.reverse_merge!({
#   nodejs: {
#     version: '10.13.0',
#   }
# })

node_version = 'latest'
node_version = node[:nodejs][:version] unless node[:nodejs].nil?
user = node[:user]
home = node[:home]

remote_file "#{home}/.default-npm-packages" do
  source 'files/.default-npm-packages'
  owner user
  mode '644'
end

execute 'install asdf-nodejs' do
  user user
  command <<-EOS
. /etc/profile.d/asdf.sh
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
EOS
  not_if "test -d #{home}/.asdf/plugins/nodejs"
end

execute 'install nodejs' do
  user user
  command <<-EOS
VER=#{node_version}
. /etc/profile.d/asdf.sh
asdf install nodejs ${VER}
if [ ${VER} = 'latest' ]; then
  asdf global nodejs $(asdf list nodejs)
else
  asdf global nodejs ${VER}
fi
asdf reshim nodejs
EOS
  not_if 'which node'
end
