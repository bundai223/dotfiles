
user = node['user']

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  execute 'install go from official binary' do
    command <<-EOL
      VERSION=1.9.2
      OS=linux
      ARCH=amd64

      tgz=go${VERSION}.${OS}-${ARCH}.tar.gz
      wget https://redirector.gvt1.com/edgedl/go/${tgz}
      tar -C /usr/local -xzf ${tgz}
      rm -f ${tgz}

      echo '* Please set path'
      echo 'export PATH=$PATH:/usr/local/go/bin'
    EOL

    not_if 'test -e /usr/local/go'
  end

  remote_file '/etc/profile.d/go.sh' do
    source 'files/go.sh'
    mode '644'
  end
when 'osx', 'darwin'
when 'arch'
  include_cookbook 'asdf'

  execute 'install golang' do
    user user
    command <<EOC
  source /opt/asdf-vm/asdf.sh
  asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
  asdf install golang latest
  asdf global golang $(asdf list golang)
  asdf reshim golang
EOC
  end
when 'opensuse'
else
end
