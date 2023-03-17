case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  include_cookbook 'jq'
when 'opensuse'
end
