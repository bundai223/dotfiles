
# ubuntu
execute 'wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb'
execute 'dpkg -i packages-microsoft-prod.deb'
execute 'apt-get update -y'
execute 'apt-get upgrade -y'

%w(
  daemonize
  dbus
  policykit-1
  dotnet-runtime-3.1
).each do |pkg|
  package pkg
end

execute 'rm -f packages-microsoft-prod.deb'
