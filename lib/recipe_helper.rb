::MItamae::RecipeContext.class_eval do
  # node hashのパラメータで必須のものを初期設定する。
  def init_node
    user = ENV['SUDO_USER'] || ENV['USER']
    case node[:platform]
    when 'osx', 'darwin'
      home = ENV['HOME']
      group = 'staff'
    when 'arch'
      home = %x[cat /etc/passwd | grep '^#{user}:' | awk -F: '!/nologin/{print $(NF-1)}'].strip
      group = user
    else
      home = %x[cat /etc/passwd | grep '^#{user}:' | awk -F: '!/nologin/{print $(NF-1)}'].strip
      group = user
    end

    repos = "#{home}/repos"
    dotfile_repos = "#{repos}/github.com/bundai223/dotfiles"
    is_wsl = run_command('uname -a | grep -i Microsoft', error: false).exit_status == 0

    node.reverse_merge!(
      user: user,
      group: group,
      home: home,
      repos: repos,
      dotfile_repos: dotfile_repos,
      is_wsl: is_wsl,
      go_root: "#{home}/.asdf/shims/"
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

# dotfileリポジトリ内へのシンボリックリンク設定
define :dotfile, source: nil, user: nil do
  dst = File.join(node[:home], params[:name])
  src = params[:source].nil? ? File.join(node[:dotfile_repos], 'config', params[:name]) : parmas[:source]
  user = params[:user].nil? ? params[:user] : node[:user]
  # puts "dst: #{dst}"
  # puts "src: #{src}"

  execute "ln -s #{src} #{dst}" do
    user user
    not_if "test -L #{dst}"
  end
end

define :get_repo, build: nil do
  reponame = params[:name]
  user = params[:user].nil? ? ENV['SUDO_USER'] || ENV['USER'] : node[:user]

  execute "get_repo #{reponame}" do
    command "source ~/.asdf/asdf.sh; ghq get -p #{reponame}"
    user user
  end

  unless params[:build].nil?
    execute "build #{reponame}" do
      command params[:build]
    end
  end
end

define :go_get do
  reponame = params[:name]
  version = 'latest'

  execute "#{node[:go_root]}/go install #{reponame}@#{version}" do
    user node[:user]
  end
end

# githubから直接バイナリを取得してインストール
define :get_bin_github_release, version: nil, version_cmd: nil, version_str: nil, release_artifact_url: nil do
  target_name = params[:name]
  version = params[:version]
  version_cmd = params[:version_cmd]
  version_str = params[:version_str]
  release_url = params[:release_artifact_url]

  execute "install #{target_name}" do
    command <<-EOCMD
      WORKDIR=work_#{version}

      cur=$(pwd)
      mkdir -p ${WORKDIR}
      cd ${WORKDIR}

      wget #{release_url} -O #{target_name}

      install #{target_name} /usr/local/bin/#{target_name}
      cd ${cur}
      rm -rf ${WORKDIR}
    EOCMD

    not_if "test -e /usr/local/bin/#{target_name} && test \"$(#{version_cmd})\" = \"#{version_str}\""
  end
end

define :yay do
  name = params[:name]

  execute "yay -S --noconfirm #{name}" do
    user node[:user]
    not_if "yay -Q #{name}"
  end
end

define :install_font do
  name = params[:name]
  # typename = File.extname(name) == 'otf' ? 'OTF' : 'TTF'
  install_path = "~/.local/share/fonts"

  directory install_path
  execute "cp #{name} #{install_path}"
end

init_node
