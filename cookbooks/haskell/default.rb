include_recipe 'dependency.rb'

# version = 'latest'
version = '9.4.2' # latestである9.4.3をインストールするとエラーになってしまう
version = node[:haskell][:version] unless node[:haskell].nil?
user = node[:user]
home = node[:home]

# remote_file "#{home}/.default-npm-packages" do
#   source 'files/.default-npm-packages'
#   owner user
#   mode '644'
# end
#
[
  { cmd: 'asdf plugin add haskell https://github.com/asdf-community/asdf-haskell.git',
    not_if: 'asdf plugin list | grep haskell' },
  { cmd: "asdf install haskell #{version}", not_if: "asdf list haskell | grep #{version}" },
  { cmd: "asdf global haskell #{version}", not_if: 'which haskell' }
].each do |op|
  source_asdf_and_execute op[:cmd] do
    user user
    not_if_ op[:not_if] unless op[:not_if].nil?
  end
end
