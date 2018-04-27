nclude_recipe 'dependency.rb'

node.reverse_merge!({
  nodejs: {
    major_version: 8,
  }
})

major_version = node[:nodejs][:major_version]

case node[:platform]
when 'debian', 'ubuntu', 'mint'
  execute "install nodejs#{major_version}" do
    command <<-EOL
      curl -sL https://deb.nodesource.com/setup_#{major_version}.x | sudo -E bash -
    EOL
  end

  package 'nodejs'

when 'fedora', 'redhat', 'amazon'
  execute "install nodejs#{major_version}" do
    command <<-EOL
      curl --silent --location https://rpm.nodesource.com/setup_#{major_version}.x | sudo bash -
    EOL
  end

  package 'nodejs'

when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end

