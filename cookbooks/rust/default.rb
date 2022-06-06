# include_recipe './dependency.rb'
include_cookbook './asdf'

# node.reverse_merge!({
#   rust: {
#     version: '10.13.0',
#   }
# })

version = 'latest'
version = node[:rust][:version] unless node[:rust].nil?
user = node[:user]
home = node[:home]

remote_file "#{home}/.default-cargo-crates" do
  source 'files/.default-cargo-crates'
  owner user
  mode '644'
end

execute 'install asdf-rust' do
  user user
  command <<-EOCMD
    source /etc/profile.d/asdf.sh
    asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
  EOCMD
  not_if "test -d #{home}/.asdf/plugins/rust"
end

[
  { cmd: 'asdf plugin add rust', not_if: 'asdf plugin list | grep rust' },
  { cmd: "asdf install rust #{version}", not_if: "asdf list rust | grep #{version}" },
  { cmd: "asdf global rust #{version}" },
  { cmd: 'asdf reshim rust' }
].each do |op|
  source_asdf_and_execute op[:cmd] do
    user user
    not_if_ op[:not_if] unless op[:not_if].nil?
  end
end

# あとでおいだす
[
  'mkdir ~/.local/share/mocword',
  'wget https://github.com/high-moctane/mocword-data/releases/download/eng20200217/mocword.sqlite.gz -O ~/.local/share/mocword/mocword.sqlite.gz',
  'gunzip ~/.local/share/mocword/mocword.sqlite.gz'
].each do |cmd|
  execute cmd do
    user user
    not_if 'test -f ~/.local/share/mocword/mocword.sqlite'
  end
end
