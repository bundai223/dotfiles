user = node['user']
home = node['home']

include_cookbook 'asdf'

remote_file "#{home}/.default-cargo-crates" do
  source 'files/.default-cargo-crates'
  owner user
  mode '644'
end

execute 'install asdf-rust' do
  user user
  command <<EOC
source /etc/profile.d/asdf.sh
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
EOC
  not_if "test -d #{home}/.asdf/plugins/rust"
end
execute 'install rust' do
  user user
  command <<EOC
source /etc/profile.d/asdf.sh
asdf install rust latest
asdf global rust $(asdf list rust)
asdf reshim rust
EOC
  not_if 'which rustup'
end
