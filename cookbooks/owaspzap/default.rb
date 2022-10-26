include_recipe 'dependency.rb'

# https://software.opensuse.org/download.html?project=home%3Acabelo&package=owasp-zap
case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  package 'owasp-zap'
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
