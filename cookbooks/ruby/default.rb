


case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  remote_file '/etc/profile.d/rbenv.sh' do
    source 'files/rbenv.sh'
    mode '644'
  end

  node.reverse_merge!({
    rbenv: {
      global: '2.5.1',
      versions: %w[
        2.5.1
      ],
    },
    'rbenv-default-gems' => {
      'default-gems' => %w[bundler neovim rubocop rcodetools ruby_parser pry pry-doc method_source],
      'install': true
    }
  })

  execute 'uninstall system ruby' do
    command <<-EOL
      apt purge -y ruby
    EOL

    only_if 'uname -a | grep Microsoft'
    only_if 'test -e /usr/bin/ruby'
  end

  include_recipe 'rbenv::system'

  execute 'install rbenv-update' do
    command <<-EOL
      p=$(rbenv root)/plugins
      test -e $p || mkdir $p
      git clone https://github.com/rkh/rbenv-update.git $p/rbenv-update
    EOL

    not_if 'test -e "$(rbenv root)/plugins/rbenv-update"'
  end

when 'osx', 'darwin'
  package 'rbenv'

when 'opensuse'
else
end

