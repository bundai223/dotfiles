case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute "echo 'deb http://download.opensuse.org/repositories/home:/cabelo/xUbuntu_21.10/ /' | sudo tee /etc/apt/sources.list.d/home:cabelo.list" do
    not_if 'test -e /etc/apt/sources.list.d/home:cabelo.list'
  end
  execute 'curl -fsSL https://download.opensuse.org/repositories/home:cabelo/xUbuntu_21.10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_cabelo.gpg > /dev/null' do
    not_if 'test -f /etc/apt/trusted.gpg.d/home_cabelo.gpg'
  end
  execute 'sudo apt update'
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
