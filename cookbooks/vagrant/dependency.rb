case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  unless node[:is_wsl]
    include_recipe 'virtualbox'
  end
when 'opensuse'
else
end
