version = "20230326-111934-3666303c"

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
      tag=#{version}
      filename=wezterm-${tag}.Ubuntu22.04.deb
      depurl=https://github.com/wez/wezterm/releases/download/${tag}/$filename
      curl -LO $depurl
      sudo apt-get install -y ./${filename}
      rm -f ./${filename}
    EOCMD
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
