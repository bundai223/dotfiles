get_repo 'Kapeli/Dash-User-Contributions'

# electron
get_repo 'pirafrank/electron-dash-docset'
execute 'build electron docset' do
  command <<-EOL
    cd #{node[:home]}/pirafrank/electron-dash-docset
    ./prepare.sh
    ./build.py
    ./pack.sh
  EOL
end
