include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'mint'
when 'ubuntu'
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

      apt update
    EOL
  end

  package 'docker-ce'

when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
when 'arch'
  execute 'install docker' do
    command "#{sudo(node[:user])}yaourt -S --noconfirm docker"
    not_if 'which docker'
  end

  execute 'install docker' do
    command "#{sudo(node[:user])}yaourt -S --noconfirm docker-compose"
    not_if 'which docker-compose'
  end
when 'opensuse'
else
end

execute "usermod -G #{node[:group]},docker #{node[:user]}"

remote_file '/etc/profile.d/docker.sh' do
  source 'files/docker.sh'
  mode '644'
  only_if 'uname -a | grep Microsoft'
end

service 'docker' do
  action [:enable, :start]
end
