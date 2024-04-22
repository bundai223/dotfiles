include_recipe 'dependency.rb'

version = '3.3.0'
url = "https://www.openssl.org/source/openssl-#{version}.tar.gz"

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  package 'build-essential'

  execute "openssl #{version}" do
    command <<~EOCMD
      mkdir work_openssl
      pushd work_openssl

      wget #{url}
      tar -xf openssl-#{version}.tar.gz
      cd openssl-#{version}

      ./config
      make
      make install

      popd

      id
    EOCMD
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
