execute 'install rustup' do
  not_if "#{sudo(node['user'])}which rustup"
  command "curl https://sh.rustup.rs -sSf | #{sudo(node['user'])}sh -s -- -y"
end

execute 'get rust src' do
  command "#{sudo(node['user'])}rustup component add rust-src"
end


# Cargo
define :cargo_install do
  # MItamae.logger.error "#{params}"
  reponame = params[:name]

  execute "cargo install #{reponame}" do
    command "#{sudo(node['user'])}cargo install --force #{reponame}"
    not_if "#{sudo(node['user'])}cargo install --list | grep #{reponame}"
  end
end

cargo_install 'racer'
cargo_install 'ripgrep'
cargo_install 'rustfmt'
