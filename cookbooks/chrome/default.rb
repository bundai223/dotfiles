
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  execute 'install google chrome' do
    command <<-EOL
      DEB=google-chrome-stable_current_amd64.deb
      URL=https://dl.google.com/linux/direct/$DEB
      curl -sOL $URL

      gdebi -n $DEB
      rm $DEB
    EOL
  end


when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
  package 'caskroom/cask/google-chrome'
when 'arch'
when 'opensuse'
else
end
