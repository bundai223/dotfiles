execute 'install rustup' do
  not_if 'which rustup'
  command 'curl https://sh.rustup.rs -sSf | sh'
end

execute 'install cargo tools' do
  command <<-EOL
    source ~/.cargo/env
    cargo install racer
    cargo install rustfmt
  EOL
end

execute 'get rust src' do
  command <<-EOL
    rustup component add rust-src
  EOL
end
