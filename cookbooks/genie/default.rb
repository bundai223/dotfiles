include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  # リポジトリの追加  
  execute 'curl -s https://packagecloud.io/install/repositories/arkane-systems/wsl-translinux/script.deb.sh | sudo bash  '
  # Genieをインストール  
  execute 'apt-get install -y systemd-genie'
when 'opensuse'
else
end

