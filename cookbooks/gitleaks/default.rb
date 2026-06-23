include_recipe 'dependency.rb'

# アップグレードしたいときはこのバージョンを更新する。
# リリース一覧: https://github.com/gitleaks/gitleaks/releases
version = '8.30.1'

case node[:platform]
when 'osx', 'darwin'
  # macOSはhomebrewで入れる。
  package 'gitleaks'
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  # Linuxはリリースのバイナリ(tar.gz)を取得して /usr/local/bin に配置する。
  execute 'install gitleaks' do
    user node['user']

    command <<~EOCMD
      GITLEAKS_VERSION=#{version}
      curl -Lo gitleaks.tar.gz "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
      tar xf gitleaks.tar.gz gitleaks
      sudo install gitleaks /usr/local/bin
      rm -f gitleaks*
    EOCMD

    not_if "gitleaks version 2>/dev/null | grep -q '#{version}'"
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
