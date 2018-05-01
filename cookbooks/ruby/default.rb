
node.reverse_merge!({
  rbenv: {
    global: '2.4.3',
    versions: %w[
      2.4.3
    ],
  },
  'rbenv-default-gems' => {
    'default-gems' => %w[ bundler ]
  }
})

include_recipe 'rbenv::system'


case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  remote_file '/etc/profile.d/rbenv.sh' do
    source 'files/rbenv.sh'
    mode '644'
  end
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
