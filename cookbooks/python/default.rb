include_recipe './dependency.rb'
include_cookbook 'uv'

user = node[:user]
home = node[:home]
# python_version = 'latest'
python_version = '3.13.0'

remote_file "#{home}/.default-python-packages" do
  source 'files/.default-python-packages'
  owner user
  mode '644'
end

execute 'install asdf-python' do
  user user
  command <<-EOS
. /etc/profile.d/asdf.sh
asdf plugin add python
EOS
  not_if 'test -d ~/.asdf/plugins/python'
end

execute 'install python' do
  user user
  command <<-EOS
export MSGPACK_PUREPYTHON=1
VER=#{python_version}
. /etc/profile.d/asdf.sh
asdf install python ${VER}
asdf set python ${VER}
asdf set -u python ${VER}
EOS
  not_if "test -d #{home}/.asdf/shims/python"
end
