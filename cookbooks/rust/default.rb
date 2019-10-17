user = node['user']
channel = 'stable'
# channel = 'nightly'

# on arch
package 'pkg-config'
package 'openssl'

# Cargo
define :cargo_install, channel: 'stable' do
  # MItamae.logger.error "#{params}"
  reponame = params[:name]
  channel = params[:channel]

  install_cmd = "cargo install --force #{reponame}"
  if channel != 'stable'
    install_cmd = "cargo install +#{channel} --force #{reponame}"
  end

  execute install_cmd do
    not_if "cargo install --list | grep #{reponame}"
    user user
  end
end

execute 'install rustup' do
  not_if "which rustup"
  command "curl https://sh.rustup.rs -sSf | sh -s -- -y"
  user user
end

execute 'source ~/.cargo/env && rustup update' do
  user user
end

execute "rustup install #{channel}" do
  not_if "rustup toolchain list"
  user user
end

execute "rustup default #{channel}" do
  not_if "rustup toolchain list | grep #{channel} | grep default"
  user user
end

execute "rustup component add rust-analysis rust-src" do
  user user
end

if channel == 'nightly'
  execute "rustup component add rust-analysis rust-src" do
    user user
  end
  cargo_install 'cargo-rls-install' # for nightly

  execute 'cargo rls-install -ny' do
    user user
  end
else
  execute "rustup component add rls" do
    user user
  end
end

cargo_install 'racer' do
  channel 'nightly'
end

cargo_install 'ripgrep'
cargo_install 'rustfmt' # 'rustfmt-nightly'

