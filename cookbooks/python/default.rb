include_recipe './dependency.rb'

user = node[:user]
home = node[:home]
python_version = 'latest'

remote_file "#{home}/.default-python-packages" do
  source 'files/.default-python-packages'
  owner user
  mode '644'
end

execute 'install asdf-python' do
  user user
  command <<-EOS
. #{home}/.asdf/asdf.sh
asdf plugin-add python
EOS
  not_if 'test -d ~/.asdf/plugins/python'
end

execute 'install python' do
  user user
  command <<-EOS
VER=#{python_version}
. #{home}/.asdf/asdf.sh
asdf install python ${VER}
asdf global python ${VER}
EOS
  not_if "test -d #{home}/.asdf/shims/python"
end



