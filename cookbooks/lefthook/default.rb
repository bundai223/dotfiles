include_recipe 'dependency.rb'

# アップグレードしたいときはこのバージョンを更新する。
# リリース一覧: https://github.com/evilmartians/lefthook/releases
target_name = 'lefthook'
version = '2.1.9'
release_url = "https://github.com/evilmartians/lefthook/releases/download/v#{version}/lefthook_#{version}_Linux_x86_64"
version_cmd = "/usr/local/bin/#{target_name} version"
version_str = version

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  # Linuxはリリースの単一バイナリを /usr/local/bin に配置する。
  get_bin_github_release target_name do
    version version
    version_cmd version_cmd
    version_str version_str
    release_artifact_url release_url
  end
when 'osx', 'darwin'
  # macOSはhomebrewで入れる。
  package 'lefthook'
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
