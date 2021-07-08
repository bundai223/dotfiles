include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  # リポジトリの追加
  package 'apt-transport-https'

  gpg_path = '/etc/apt/trusted.gpg.d/wsl-transdebian.gpg'
  execute 'gpg' do
    command <<-EOCMD
      wget -O #{gpg_path} https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg
      chmod a+r #{gpg_path}
    EOCMD
    not_if "ls #{gpg_path}"
  end

  source_list_path = '/etc/apt/sources.list.d/wsl-transdebian.list'
  # distro = run_command("cat /etc/*-release | grep DISTRIB_CODENAME | sed 's/DISTRIB_CODENAME=//'").stdout.strip
  distro = run_command("lsb_release -a | grep -i codename | awk '{print $2}'").stdout.strip

  file source_list_path do
    content <<-EOCMD
      deb https://arkane-systems.github.io/wsl-transdebian/apt/ #{distro} main
      deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ #{distro} main
    EOCMD
    not_if "ls #{source_list_path}"
    mode '644'
  end

  # Genieをインストール
  execute 'apt-get install -y systemd-genie'
when 'opensuse'
else
end
