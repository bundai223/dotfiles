include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute 'install wezterm from repo' do
    command <<~EOCMD
      filename=wezterm-20221119-145034-49b9839f.Ubuntu22.04.deb
      depurl=https://github.com/wez/wezterm/releases/download/20221119-145034-49b9839f/$filename
      curl -LO $depurl
      sudo apt install -y ./${filename}
      rm -f ./${filename}
    EOCMD
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
