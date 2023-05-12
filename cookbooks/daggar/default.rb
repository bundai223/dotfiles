include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute 'install daggar' do
    command <<-EOCMD
      cd /usr/local
      curl -L https://dl.dagger.io/dagger/install.sh | sh
    EOCMD
    not_if 'test -e /usr/local/bin/dagger'
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
