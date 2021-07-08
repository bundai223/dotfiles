include_cookbook 'asdf'

case node[:platform]
when 'debian', 'ubuntu', 'mint'
  %w(
    autoconf
    bison
    build-essential
    libssl-dev
    libyaml-dev
    libreadline6-dev
    zlib1g-dev
    libncurses5-dev
    libffi-dev
    libgdbm6
    libgdbm-dev
    libdb-dev
  ).each {|p| package p }

when 'arch'
  %w(
    base-devel
    libffi
    libyaml
    openssl
    zlib
  ).each {|p| package p }

when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
when 'opensuse'
end
