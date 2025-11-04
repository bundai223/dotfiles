include_recipe 'dependency.rb'

target_name = 'yazi'
version = 'v25.5.31'
release_url = "https://github.com/sxyazi/yazi/releases/download/#{version}/yazi-x86_64-unknown-linux-gnu.zip"
version_cmd = "/usr/local/bin/#{target_name} -v"
version_str = "#{version}"

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  get_bin_github_release target_name do
    version version
    version_cmd version_cmd
    version_str version_str
    release_artifact_url release_url
    zipped true
  end
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
end
