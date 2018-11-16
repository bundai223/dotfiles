include_recipe 'dependency.rb'

node.reverse_merge!({
  nvm: {
    version: 'v0.33.11',
  },
  nodejs: {
    version: '10.13.0',
    major_version: 10,
  }
})

major_version = node[:nodejs][:major_version]
nvm_version = node[:nvm][:version]

case node[:platform]
when 'debian', 'ubuntu', 'mint'
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
  yay 'nvm'

  execute 'nvm install ${node[:nodejs][:version]}'
when 'opensuse'
else
end

