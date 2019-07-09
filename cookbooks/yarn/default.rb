
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  execute 'apt purge -y cmdtest'

  execute "install yarn" do
    command <<-EOL
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
      apt update
    EOL

    not_if 'ls /etc/apt/sources.list.d | grep yarn.list'
  end

  package 'yarn'

when 'fedora', 'redhat', 'amazon'
  execute "install yarn" do
    command <<-EOL
      curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
    EOL
  end

  package 'yarn'

when 'osx', 'darwin'
when 'arch'
  package 'yarn'
when 'opensuse'
else
end

remote_file '/etc/profile.d/yarn.sh' do
  source 'files/yarn.sh'
  mode '644'
end

execute 'yarn global add vue-language-server'
execute 'yarn global add javascript-typescript-langserver'
execute 'yarn global add tern js-beautify eslint jslint tslint'
