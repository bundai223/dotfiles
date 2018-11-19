::MItamae::RecipeContext.class_eval do
  # node hashのパラメータで必須のものを初期設定する。
  def init_node
    user = ENV['SUDO_USER'] || ENV['USER']
    case node[:platform]
    when 'osx', 'darwin'
      home = ENV['HOME']
      group = 'staff'
    when 'arch'
      home = %x[cat /etc/passwd | grep #{user} | awk -F: '!/nologin/{print $(NF-1)}'].strip
      group = 'users'
    else
      home = %x[cat /etc/passwd | grep #{user} | awk -F: '!/nologin/{print $(NF-1)}'].strip
      group = user
    end

    is_wsl = run_command('uname -a | grep Microsoft', error: false).exit_status == 0

    node.reverse_merge!(
      user: user,
      group: group,
      home: home,
      is_wsl: is_wsl
    )
  end

  def update_package
    case node[:platform]
    when 'arch'
      execute 'yay -Syy'
    when 'osx', 'darwin'
      execute 'brew update'
    when 'fedora', 'redhat', 'amazon'
      # execute 'yum update -y' # '区別なし'
    when 'debian', 'ubuntu', 'mint'
      execute 'apt update -y'
    when 'opensuse'
    else
    end
  end

  def upgrade_package
    case node[:platform]
    when 'arch'
      execute 'yay -Syu --noconfirm'
    when 'osx', 'darwin'
      execute 'brew upgrade'
    when 'fedora', 'redhat', 'amazon'
      execute 'yum update -y' # 区別なし
    when 'debian', 'ubuntu', 'mint'
      execute 'apt upgrade -y'
    when 'opensuse'
    else
    end
  end

  def include_cookbook(name)
    root_dir = File.expand_path('../..', __FILE__)
    include_recipe File.join(root_dir, 'cookbooks', name, 'default')
  end

  def include_role(name)
    root_dir = File.expand_path('../..', __FILE__)
    include_recipe File.join(root_dir, 'roles', name, 'default')
  end

  def has_package?(name)
    result = run_command("dpkg-query -f '${Status}' -W #{name.shellescape} | grep -E '^(install|hold) ok installed$'", error: false)
    result.exit_status == 0
  end

  def sudo(user)
    if node[:platform] == 'darwin' || node[:platform] == 'osx'
      ''
    else
      "sudo -u #{user} -i "
    end
  end

  def run_as(user, cmd)
    if node[:platform] == 'darwin' || node[:platform] == 'osx'
      cmd
    else
      "su - #{user} -c \"cd ${PWD} && #{cmd}\""
    end
  end
end

::MItamae::ResourceContext.class_eval do
  def sudo(user)
    if node[:platform] == 'darwin' || node[:platform] == 'osx'
      ''
    else
      "sudo -u #{user} -i "
    end
  end

  def run_as(user, cmd)
    if node[:platform] == 'darwin' || node[:platform] == 'osx'
      cmd
    else
      "su - #{user} -c \"cd ${PWD} && #{cmd}\""
    end
  end
end

define :dotfile do
  dotfile = File.join(node[:home], params[:name])
  #puts "aaaaa #{dotfile}"
  #puts "aaaaa #{File.expand_path("../../config/#{params[:name]}", __FILE__)}"
  link dotfile do
    to File.expand_path("../../config/#{params[:name]}", __FILE__)
    not_if "test -e #{dotfile}"
  end
end

define :get_repo do
  reponame = params[:name]

  if node[:platform] == 'osx' || node[:platform] == 'darwin'
    execute "get_repo #{reponame}" do
      command "~/go/bin/ghq get -p #{reponame}"
      not_if "test -d ~/repos/github.com/#{reponame}"
    end
  else
    execute "get_repo #{reponame}" do
      command run_as(node[:user], "ghq get -p #{reponame}")
      not_if "test -d #{node[:home]}/repos/github.com/#{reponame}"
    end
  end
end

define :go_get do
  reponame = params[:name]

  execute "go get #{reponame}" do
    command "#{sudo(node['user'])}go get #{reponame}"
  end
end

define :yay do
  name = params[:name]

  execute "#{sudo(node[:user])} yay -S --noconfirm #{name}" do
    not_if "yay -Q #{name}"
  end
end

define :install_font do
  name = params[:name]
  typename = File.extname(name) == 'otf' ? 'OTF' : 'TTF'
  install_path = "/usr/share/fonts/#{typename}/"

  directory install_path
  execute "cp #{name} #{install_path}"
end

init_node
