


case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  remote_file '/etc/profile.d/rbenv.sh' do
    source 'files/rbenv.sh'
    mode '644'
  end

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

when 'osx', 'darwin'
  package 'rbenv'

when 'opensuse'
else
end
