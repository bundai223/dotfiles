# cookbook for ruby

user = node['user']
home = node['home']

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  node.reverse_merge!({
    rbenv: {
      rbenv_root: '/usr/local/rbenv',
      global: '2.6.5',
      versions: %w[
        "2.6.5"
      ],
    },
    'rbenv-default-gems' => {
      'default-gems' => %w[bundler neovim rubocop rcodetools ruby_parser pry pry-doc method_source solargraph colorls],
      install: true
    }
  })

  template '/etc/profile.d/rbenv.sh' do
    action :create
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
    not_if "test -e #{rbenv_plugins}/rbenv-update"
  end
when 'arch'
  include_cookbook 'asdf'

  remote_file "#{home}/.default-gems" do
    source 'files/.default-gems'
    owner user
    mode '644'
  end
  execute 'install ruby' do
    command <<EOC
  source /opt/asdf-vm/asdf.sh
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby latest
  asdf global ruby $(asdf list ruby)
EOC
  end

when 'osx', 'darwin'
  package 'rbenv'

when 'opensuse'
else
end


# execute 'yard gems'
# execute 'yard config --gem-install-yri'
