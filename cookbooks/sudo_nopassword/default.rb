case node[:platform]
when 'osx', 'darwin'
  # nothing to do
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch', 'opensuse'
  file "/etc/sudoers.d/#{node[:user]}" do
    content <<-EOL
      #{node[:user]} ALL=NOPASSWD: ALL
    EOL

    not_if "test -e /etc/sudoers.d/#{node[:user]}"
  end
else
end
