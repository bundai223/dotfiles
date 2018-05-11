
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'gdebi'
  package 'libxss1'

  execute 'install gitkraken' do
    command <<-EOL
      DEB=gitkraken-amd64.deb
      URL=https://release.gitkraken.com/linux/$DEB
      curl -sOL $URL

      gdebi -n $DEB
      rm $DEB
    EOL
  end

when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
  package 'peco'

when 'arch'
when 'opensuse'
else
end

