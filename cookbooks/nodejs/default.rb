include_recipe 'dependency.rb'

user = node['user']
home = node['home']

node.reverse_merge!({
  nvm: {
    version: 'v0.33.11',
  },
  nodejs: {
    version: '10.13.0',
    major_version: 10,
  }
})

node_version = node[:nodejs][:version]
major_version = node[:nodejs][:major_version]

case node[:platform]
when 'debian', 'ubuntu', 'mint'
  nvm_version = node[:nvm][:version]

  execute 'nvm install' do
    command "curl -o- https://raw.githubusercontent.com/creationix/nvm/#{nvm_version}/install.sh | bash"
  end
  # execute "install nodejs#{major_version}" do
  #   command <<-EOL
  #     curl -sL https://deb.nodesource.com/setup_#{major_version}.x | sudo -E bash -
  #   EOL
  # end
  #
  # package 'nodejs'

when 'fedora', 'redhat', 'amazon'
  execute "install nodejs#{major_version}" do
    command <<-EOL
      curl --silent --location https://rpm.nodesource.com/setup_#{major_version}.x | sudo bash -
    EOL
  end

  package 'nodejs'

when 'osx', 'darwin'
when 'arch'
  include_cookbook 'asdf'

  remote_file "#{home}/.default-npm-packages" do
    source 'files/.default-npm-packages'
    owner user
    mode '644'
  end
  execute 'install nodejs' do
    user user
    command <<EOC
source /opt/asdf-vm/asdf.sh
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs latest
asdf global nodejs $(asdf list nodejs)
EOC
  end
when 'opensuse'
else
end

