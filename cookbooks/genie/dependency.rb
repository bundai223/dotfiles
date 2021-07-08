# ubuntu
# execute 'wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb'
# execute 'dpkg -i packages-microsoft-prod.deb'
%w[
  daemonize
  dbus
  dotnet-runtime-5.0
  gawk
  libc6
  libstdc++6
  policykit-1
  systemd
  systemd-container
].each do |pkg|
  package pkg
end

# execute 'rm -f packages-microsoft-prod.deb'
