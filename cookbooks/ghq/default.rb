# frozen_string_literal: true

include_cookbook 'asdf'

version = 'latest'

user = node['user']
home = node['home']

execute 'install asdf-ghq' do
  user user
  command <<EOCMD
  . /etc/profile.d/asdf.sh
  asdf plugin add ghq
EOCMD
  not_if "test -d #{home}/.asdf/plugins/ghq"
end

execute 'install ghq' do
  user user
  command <<EOCMD
  VER=#{version}
  . /etc/profile.d/asdf.sh
  asdf install ghq ${VER}
  if [ ${VER} = 'latest' ]; then
    asdf global ghq $(asdf list ghq)
  else
    asdf global ghq ${VER}
  fi
  asdf reshim ghq
EOCMD
  not_if 'test -e ~/.asdf/shims/ghq'
end
