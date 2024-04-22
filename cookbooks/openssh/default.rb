include_recipe 'dependency.rb'

version = '9.7'
url = "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-#{version}p1.tar.gz"

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  package 'openssh-client'

  execute 'install openssh' do
    command <<~EOCMD

    mkdir work_openssh
    pushd work_openssh
    wget --no-check-certificate #{url}
    tar -zxvf openssh-#{version}p1.tar.gz

    cd openssh-#{version}p1
      ./configure
    make
    make install

    popd
    EOCMD
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
