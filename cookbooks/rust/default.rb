user = node['user']
home = node['home']

include_cookbook 'asdf'

remote_file "#{home}/.default-cargo-crates" do
  source 'files/.default-cargo-crates'
  owner user
  mode '644'
end

execute 'install rust' do
  user user
  command <<EOC
source /opt/asdf-vm/asdf.sh
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf install rust latest
asdf global rust $(asdf list rust)
EOC
end
