include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute 'make install' do
    command <<~EOCMD
      git clone https://github.com/awslabs/git-secrets.git
      cd git-secrets
      make install
    EOCMD
    not_if 'which git-secrets'
  end

  execute 'rm -rf git-secrets' do
    only_if 'test -e git-secrets'
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
