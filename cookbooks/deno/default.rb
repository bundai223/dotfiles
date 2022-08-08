include_recipe 'dependency.rb'
include_cookbook './asdf'

version = 'latest'
version = node[:deno][:version] unless node[:deno].nil?
user = node[:user]
home = node[:home]

# remote_file "#{home}/.default-npm-packages" do
#   source 'files/.default-npm-packages'
#   owner user
#   mode '644'
# end
#
[
  { cmd: 'asdf plugin add deno https://github.com/asdf-community/asdf-deno.git',
    not_if: 'asdf plugin list | grep deno' },
  { cmd: "asdf install deno #{version}", not_if: "asdf list deno | grep #{version}" },
  { cmd: "asdf global deno #{version}", not_if: 'which deno' }
].each do |op|
  source_asdf_and_execute op[:cmd] do
    user user
    not_if_ op[:not_if] unless op[:not_if].nil?
  end
end
