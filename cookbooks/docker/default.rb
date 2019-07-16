include_recipe 'dependency.rb'

dotfile_repos = node[:dotfile_repos]
docker_compose_version = '1.21.2'

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
      curl -L https://github.com/docker/compose/releases/download/#{docker_compose_version}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
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

execute "update docker's zsh completions." do
  command "curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker > #{dotfile_repos}/config/zsh/functions/completions/_docker"
end

execute "update docker-compose's zsh completions." do
  command "curl -L https://raw.githubusercontent.com/docker/compose/#{docker_compose_version}/contrib/completion/zsh/_docker-compose> #{dotfile_repos}/config/zsh/functions/completions/_docker-compose"
end

