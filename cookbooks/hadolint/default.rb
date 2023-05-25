include_recipe 'dependency.rb'

target_name = 'hadolint'
version = '2.12.0'
release_url = "https://github.com/hadolint/hadolint/releases/download/v#{version}/hadolint-Linux-x86_64"
version_cmd = "/usr/local/bin/#{target_name} -v"
version_str = "Haskell Dockerfile Linter #{version}"

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  get_bin_github_release target_name do
    version version
    version_cmd version_cmd
    version_str version_str
    release_artifact_url release_url
  end
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
end
