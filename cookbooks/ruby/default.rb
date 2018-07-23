


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
      'default-gems' => %w[bundler neovim rubocop]
    }
  })

  execute 'uninstall system ruby' do
    commands <<-EOL
      apt purge -y ruby
    EOL

    only_if 'uname -a | grep Microsoft'
    only_if 'test -e /usr/bin/ruby'
  end

  include_recipe 'rbenv::system'

  execute 'install rbenv-update' do
    command <<-EOL
      mkdir "$(rbenv root)/plugins"
      git clone git clone https://github.com/rkh/rbenv-update.git "$(rbenv root)/plugins/rbenv-update"
    EOL

    not_if 'test -e "$(rbenv root)/plugins/rbenv-update"'
  end

when 'osx', 'darwin'
  package 'rbenv'

when 'opensuse'
else
end
