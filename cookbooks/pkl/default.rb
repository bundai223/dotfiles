# https://github.com/apple/pkl.git

include_recipe 'dependency.rb'

case node["kernel"]["machine"]
when "x86_64"
  url = "https://github.com/apple/pkl/releases/download/0.25.1/pkl-linux-amd64"
when "aarch64"
  url = "https://github.com/apple/pkl/releases/download/0.25.1/pkl-linux-aarch64"
end

# execute "curl -L -o pkl #{url}"
[
  "wget -q #{url} -O pkl",
  "chmod +x pkl",
  "mv pkl ~/.local/bin/",
].map do |cmd|
  execute cmd do
    user node['user']
    not_if "test -e ~/.local/bin/pkl"
  end
end


# case node[:platform]
# when 'arch'
#   raise NotImplementedError
# when 'osx', 'darwin'
#   raise NotImplementedError
# when 'fedora', 'redhat', 'amazon'
#   raise NotImplementedError
# when 'debian', 'ubuntu', 'mint'
#   raise NotImplementedError
# when 'opensuse'
#   raise NotImplementedError
# else
#   raise NotImplementedError
# end
