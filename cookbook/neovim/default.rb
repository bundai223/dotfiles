
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'software-properties-common'
  execute 'add-apt-repository ppa:neovim-ppa/stable' do
    run_command 'add-apt-repository ppa:neovim-ppa/stable'
    run_command 'apt-get update'
  end
  package 'python-dev'
  package 'python-pip'
  package 'python3-dev'
  package 'python3-pip'
  package 'neovim'

when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
  package 'nvim'
when 'arch'
when 'opensuse'
else
end

execute 'install gem package' do
  command <<-EOL
    gem install neovim
  EOL
end

execute 'install python package' do
  command <<-EOL
    pip3 install --upgrade neovim
    pip install --upgrade neovim
  EOL
end
