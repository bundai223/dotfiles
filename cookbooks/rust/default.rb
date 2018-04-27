
execute 'install rustup' do
  not_if 'which rustup'
  command 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
end

execute 'install racer' do
  command <<-EOL
    . ~/.cargo/env
    cargo install racer
  EOL

  not_if <<-EOL
    . ~/.cargo/env
    which racer
  EOL
end

execute 'install rustfmt' do
  command <<-EOL
    . ~/.cargo/env
    cargo install rustfmt
  EOL

  not_if <<-EOL
    . ~/.cargo/env
    which rustfmt
  EOL
end

execute 'get rust src' do
  command <<-EOL
    . ~/.cargo/env
    rustup component add rust-src
  EOL
end
