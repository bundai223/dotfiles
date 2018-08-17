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

    not_if 'uname -a | grep Microsoft'
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

    not_if 'uname -a | grep Microsoft'
  end

  package 'docker-ce' do
    not_if 'uname -a | grep Microsoft'
  end

  ### WSL
  execute 'install docker v17.09.0' do
    command <<-EOL
      curl -O https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_17.09.0~ce-0~debian_amd64.deb
      dpkg -i docker-ce_17.09.0\~ce-0\~debian_amd64.deb
      rm docker-ce_17.09.0\~ce-0\~debian_amd64.deb
    EOL
  end
  ### WSL

  execute 'install docker-compose' do
    command <<-EOL
      curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
    EOL
    not_if 'which docker-compose'
  end

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

#remote_file '/etc/profile.d/docker.sh' do
#  source 'files/docker.sh'
#  mode '644'
#  only_if 'uname -a | grep Microsoft'
#end

service 'docker' do
  action [:enable, :start]
  not_if 'uname -a | grep Microsoft'
end
