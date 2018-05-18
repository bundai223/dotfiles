
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  # dependent cookbook
  #include_cookbook 'git'
  #include_cookbook 'ghq'

  package 'locate'
  package 'cmake'
  package 'build-essential'
  package 'checkinstall'
  package 'autoconf'
  package 'pkg-config'
  package 'libtool'
  package 'python-sphinx'
  package 'wget'
  package 'libcunit1-dev'
  package 'nettle-dev'
  package 'libyaml-dev'
  package 'libuv-dev'

  execute "#{sudo(node[:user])}ghq get h2o/h2o"
  execute 'install h2o' do
    command <<-EOL
      set -eu
      #{sudo(node[:user])}cd ~/repos/github.com/h2o/h2o
      cmake -DWITH_BUNDLED_SSL=on .
      make
      make install
    EOL

    not_if 'test -e /usr/local/bin/h2o'
  end

when 'fedora', 'redhat', 'amazon'
  package 'git-flow'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
