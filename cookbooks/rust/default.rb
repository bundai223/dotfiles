user = node['user']

execute 'install rustup' do
  not_if "#{sudo(user)}which rustup"
  command "curl https://sh.rustup.rs -sSf | #{sudo(user)}sh -s -- -y"
end

execute 'rustup update' do
  user user
end

execute 'install toolchain nightly' do
  not_if "#{sudo(user)}rustup toolchain list |grep nightly"
  command "#{sudo(user)}rustup install nightly"
end

execute 'default toolchain nightly' do
  not_if "#{sudo(user)}rustup toolchain list | grep nightly | grep default"
  command "#{sudo(user)}rustup default nightly"
end

execute 'get rust component' do
  command "#{sudo(user)}rustup component add rls rust-analysis rust-src"
  # rustfmt-preview
end

# Cargo
define :cargo_install do
  # MItamae.logger.error "#{params}"
  reponame = params[:name]

  execute "cargo install #{reponame}" do
    command "#{sudo(user)}cargo install --force #{reponame}"
    not_if "#{sudo(user)}cargo install --list | grep #{reponame}"
  end
end

cargo_install 'racer'
cargo_install 'ripgrep'
cargo_install 'rustfmt' # 'rustfmt-nightly'
