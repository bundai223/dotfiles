case node[:platform]
when 'arch'
  include_cookbook 'jq'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
  include_cookbook 'jq'
when 'debian', 'ubuntu', 'mint'
  include_cookbook 'jq'
when 'opensuse'
end
