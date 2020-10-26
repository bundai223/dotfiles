# install appimage

appimage_root = '~/.appimages'
appimage_files = "#{appimage_root}/src"
appimage_opt = "#{appimage_root}/opt"

user = node[:user]

[appimage_files, appimage_opt].each do |dir|
  execute "mkdir -p #{dir}" do
    user user
    not_if "ls #{dir}"
  end
end

define :install_appimage, user: nil, url: nil, version: nil do
  appname = params[:name]

  user = params[:user]
  appimage_url = params[:url]
  version = params[:version]

  appimage_ver_name = "#{appname}-#{version}.AppImage"
  appimage_opt_name = "#{appname}.AppImage"

  appimage_ver_path = "#{appimage_files}/#{appimage_ver_name}"
  appimage_opt_path = "#{appimage_opt}/#{appimage_opt_name}"

  execute "wget #{appimage_url} -O #{appimage_ver_path}" do
    user user
    not_if "ls #{appimage_ver_path}"
  end

  execute "chmod +x #{appimage_ver_path}" do
    user user
    only_if "ls #{appimage_ver_path}"
  end

  execute "ln -s #{appimage_ver_path} #{appimage_opt_path}" do
    user user
    not_if "ls #{appimage_opt_path}"
  end
end
