include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'mint'
when 'ubuntu'
  unless node[:is_wsl]
    execute 'install docker v17.09.0' do
      command <<-EOL
        curl -O https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_17.09.0~ce-0~debian_amd64.deb
        dpkg -i docker-ce_17.09.0\~ce-0\~debian_amd64.deb
        rm docker-ce_17.09.0\~ce-0\~debian_amd64.deb
      EOL
    end
  else
    execute 'add docker official gpg' do
      command <<-EOL
        set -xu
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo apt-key fingerprint 0EBFCD88
      EOL
    end

    execute 'add repository' do
      command <<-EOL
        set -xu

        add-apt-repository \
          "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) \
          stable"
      EOL
    end

    update_package
    package 'docker-ce'
  end

  execute 'install docker-compose' do
    command <<-EOL
      curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
    EOL
    not_if 'which docker-compose'
  end

when 'fedora', 'redhat', 'amazon'
  package 'yum-utils'
  package 'device-mapper-persistent-data'
  package 'lvm2'

  execute 'yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'
  package 'docker-ce'
  package 'docker-ce-cli'
  package 'containerd.io'

when 'osx', 'darwin'

when 'arch'
  yay 'docker'
  yay 'docker-compose'
when 'opensuse'
else
end

execute "usermod -G #{node[:group]},docker #{node[:user]}"

unless node[:is_wsl]
  service 'docker' do
    action [:enable, :start]
  end
end
