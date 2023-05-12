# frozen_string_literal: true

include_cookbook 'asdf'

# version = 'latest'
version = '1.20'

user = node['user']
home = node['home']

execute 'install asdf-golang' do
  user user
  command <<EOCMD
  . /etc/profile.d/asdf.sh
  asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
EOCMD
  not_if "test -d #{home}/.asdf/plugins/golang"
end

execute 'install golang' do
  user user
  command <<EOCMD
  VER=#{version}
  . /etc/profile.d/asdf.sh
  asdf install golang ${VER}
  if [ ${VER} = 'latest' ]; then
    asdf global golang $(asdf list golang)
  else
    asdf global golang ${VER}
  fi
  asdf reshim golang
EOCMD
  not_if 'test -e ~/.asdf/shims/go'
end
