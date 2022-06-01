include_recipe './dependency.rb'
include_cookbook './asdf'

# node.reverse_merge!({
#   nodejs: {
#     version: '10.13.0',
#   }
# })

version = 'latest'
version = node[:nodejs][:version] unless node[:nodejs].nil?
user = node[:user]
home = node[:home]

remote_file "#{home}/.default-npm-packages" do
  source 'files/.default-npm-packages'
  owner user
  mode '644'
end

[
  { cmd: 'asdf plugin add nodejs', not_if: 'asdf plugin list | grep nodejs' },
  { cmd: "asdf install nodejs #{version}", not_if: "asdf list nodejs | grep #{version}" },
  { cmd: "asdf global nodejs #{version}", not_if: 'which nodejs' }
].each do |op|
  source_asdf_and_execute op[:cmd] do
    user user
    not_if_ op[:not_if] unless op[:not_if].nil?
  end
end
