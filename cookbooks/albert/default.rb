include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute "install albert" do
  command <<EOCMD
    echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_22.10/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
    curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_22.10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
    apt update
    apt install albert
EOCMD
    not_if 'which albert'
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
