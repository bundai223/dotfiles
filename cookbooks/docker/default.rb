include_recipe 'dependency.rb'

dotfile_repos = node[:dotfile_repos]
docker_compose_version = '1.21.2'

case node[:platform]
when 'debian', 'mint'
when 'ubuntu'
  # wslはなにもしない
  unless node[:is_wsl]
    # TODO: install docker
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

unless node[:is_wsl]
  execute "usermod -G #{node[:group]},docker #{node[:user]}"

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

