execute 'install rustup' do
  not_if "#{sudo(node['user'])}which rustup"
  command "curl https://sh.rustup.rs -sSf | #{sudo(node['user'])}sh -s -- -y"
end

execute 'get rust src' do
  command "#{sudo(node['user'])}rustup component add rust-src"
end


# Cargo
define cargo_install do
  reponame = params[:name]

  execute "cargo install #{reponame}" do
    command "#{sudo(node['user'])}cargo install #{reponame}"
    not_if "#{sudo(node['user'])}which #{reponame}"
  end
end

cargo_install 'racer'
cargo_install 'rustfmt'
cargo_install 'ripgrep'
