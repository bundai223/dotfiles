


case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  node.reverse_merge!({
    rbenv: {
      rbenv_root: '/usr/local/rbenv',
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

  conf_path = '/etc/profile.d/rbenv.sh'
  template conf_path do
    action :create
    source 'files/rbenv.sh.erb'
    mode '644'
    variables(rbenv_root: node[:rbenv][:rbenv_root])
  end

  if node[:is_wsl]
    execute 'apt purge -y ruby' do
      only_if 'test -e /usr/bin/ruby'
    end
  end

  include_recipe 'rbenv::system'

  rbenv_plugins = "#{node[:rbenv][:rbenv_root]}/plugins"

  directory rbenv_plugins
  git "#{rbenv_plugins}/rbenv-update" do
    repository 'https://github.com/rkh/rbenv-update.git'
  end

when 'osx', 'darwin'
  package 'rbenv'

when 'opensuse'
else
end


# gem_package 'solargraph'
# execute 'yard gems'
# execute 'yard config --gem-install-yri'
