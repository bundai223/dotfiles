


case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  rbenv_path = '/etc/profile.d/rbenv.sh'
  remote_file rbenv_path do
    source 'files/rbenv.sh'
    mode '644'
  end

  node.reverse_merge!({
    rbenv: {
      global: '2.5.1',
      versions: %w[
        "2.5.1"
      ],
    },
    'rbenv-default-gems' => {
      'default-gems' => %w[bundler neovim rubocop rcodetools ruby_parser pry pry-doc method_source solargraph],
      install: true
    }
  })

  execute 'apt purge -y ruby' do
    only_if 'uname -a | grep Microsoft && test -e /usr/bin/ruby'
  end

  include_recipe 'rbenv::system'

  rbenv_plugins = '$(rbenv root)/plugins'

  directory rbenv_plugins
  git "#{rbenv_plugins}/rbenv-update" do
    repository 'https://github.com/rkh/rbenv-update.git'
  end

when 'osx', 'darwin'
  package 'rbenv'

when 'opensuse'
else
end


gem_package 'solargraph'
execute 'yard gems'
execute 'yard config --gem-install-yri'
