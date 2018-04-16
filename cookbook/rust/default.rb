execute 'install rustup' do
  not_if 'which rustup'
  command 'curl https://sh.rustup.rs -sSf | sh'
end

