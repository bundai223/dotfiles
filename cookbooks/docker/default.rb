include_recipe 'dependency.rb'

dotfile_repos = node[:dotfile_repos]
docker_compose_version = '2.6.0'

home = node[:home]
user = node[:user]
group = node[:group]

case node[:platform]
when 'debian', 'mint'
when 'ubuntu'

  directory "#{home}/.docker/cli-plugins" do
    owner user
    group group
    mode '755'
  end
  execute 'install docker-compose' do
    command <<-EOL
      compose_path=~/.docker/cli-plugins/docker-compose
      curl -L https://github.com/docker/compose/releases/download/v#{docker_compose_version}/docker-compose-$(uname -s)-$(uname -m) -o ${compose_path}
      chmod +x ${compose_path}
    EOL
    user user
    # not_if 'which docker-compose'
  end

when 'fedora', 'redhat', 'amazon'
  # https://matsuand.github.io/docs.docker.jp.onthefly/engine/security/rootless/

when 'osx', 'darwin'

when 'arch'
  # yay 'docker'
  # https://matsuand.github.io/docs.docker.jp.onthefly/engine/security/rootless/

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

