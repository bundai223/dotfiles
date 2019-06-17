# include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  get_repo 'koron/cmigemo' do
    build <<-EOCMD
      ./configure
      make gcc
      make gcc-dict
      sudo make gcc-install
    EOCMD
  end
when 'osx', 'darwin'
  package 'migemo'
when 'arch'
  package 'migemo'
when 'opensuse'
else
end
