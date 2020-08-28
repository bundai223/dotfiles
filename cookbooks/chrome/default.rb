# install chrome
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  execute 'add repo' do
    command <<-EOCMD
      sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
      wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
      apt-get update
    EOCMD

    not_if 'test -f /etc/apt/sources.list.d/google.list'
  end

  package 'google-chrome-stable'

when 'fedora', 'redhat', 'amazon'
  # not implemented
when 'osx', 'darwin'
  package 'caskroom/cask/google-chrome'
when 'arch'
  include_cookbook 'yay'
  yay 'google-chrome'
when 'opensuse'
  # not implemented
else
  # not implemented
end
