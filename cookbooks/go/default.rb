include_cookbook 'asdf'

version = 'latest'

user = node['user']
home = node['home']

execute 'install asdf-golang' do
  user user
  command <<EOC
. /etc/profile.d/asdf.sh
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
EOC
  not_if "test -d #{home}/.asdf/plugins/golang"
end

execute 'install golang' do
  user user
  command <<EOC
VER=#{version}
. /etc/profile.d/asdf.sh
asdf install golang ${VER}
if [ ${VER} = 'latest' ]; then
  asdf global golang $(asdf list golang)
else
  asdf global golang ${VER}
fi
asdf reshim golang
EOC
  not_if '. /etc/profile.d/asdf.sh; which go'
end
