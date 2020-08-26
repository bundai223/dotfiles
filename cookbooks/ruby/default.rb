# cookbook for ruby
include_recipe './dependency.rb'

ruby_version = 'latest'
user = node['user']
home = node['home']

remote_file "#{home}/.default-gems" do
  source 'files/.default-gems'
  owner user
  mode '644'
end

execute 'install asdf-ruby' do
  user user
  command <<-EOS
. /etc/profile.d/asdf.sh
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
EOS
  not_if "test -d #{home}/.asdf/plugins/ruby"
end

execute 'install ruby' do
  user user
  command <<-EOS
VER=#{ruby_version}
. /etc/profile.d/asdf.sh
asdf install ruby ${VER}
if [ ${VER} = 'latest' ]; then
  asdf global ruby $(asdf list ruby)
else
  asdf global ruby ${VER}
fi
asdf reshim ruby
EOS
  not_if 'which ruby'
end

