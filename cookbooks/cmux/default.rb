case node[:platform]
when 'osx', 'darwin'
  cmux_app = '/Applications/cmux.app'

  execute 'install cmux' do
    command 'brew install --cask cmux'
    not_if "test -d '#{cmux_app}' || brew list --cask cmux >/dev/null 2>&1"
  end
else
  raise NotImplementedError, 'cmux supports macOS only'
end
