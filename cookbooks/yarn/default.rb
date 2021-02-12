include_cookbook 'nodejs'
include_cookbook 'asdf'

case node[:platform]
when 'debian', 'ubuntu', 'mint'
  source_asdf_and_execute 'npm install --global yarn' do
    user node[:user]
    not_if 'which yarn'
  end

when 'fedora', 'redhat', 'amazon'
  source_asdf_and_execute 'npm install --global yarn' do
    user node[:user]
    not_if 'which yarn'
  end

when 'osx', 'darwin'
when 'arch'
  source_asdf_and_execute 'npm install --global yarn' do
    user node[:user]
    not_if 'which yarn'
  end

when 'opensuse'
else
end

remote_file '/etc/profile.d/yarn.sh' do
  source 'files/yarn.sh'
  mode '644'
end
