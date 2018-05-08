execute 'install rustup' do
  not_if "#{sudo(node['user'])}which rustup"
  command "curl https://sh.rustup.rs -sSf | #{sudo(node['user'])}sh -s -- -y"
end

execute 'install racer' do
  command "#{sudo(node['user'])}cargo install racer"
  not_if "#{sudo(node['user'])}which racer"
end

execute 'install rustfmt' do
  command "#{sudo(node['user'])}cargo install rustfmt"
  not_if "#{sudo(node['user'])}which rustfmt"
end

execute 'get rust src' do
  command "#{sudo(node['user'])}rustup component add rust-src"
end
