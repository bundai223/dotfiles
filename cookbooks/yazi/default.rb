include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  get_bin_github_release 'yazi' do
    release_artifact_url 'https://github.com/sxyazi/yazi/releases'
    version 'v25.5.31'
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
