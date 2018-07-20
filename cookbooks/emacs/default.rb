case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'emacs'
when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end

execute 'spacemacs' do
  command <<-EOL
    git clone https://github.com/syl20bnr/spacemacs #{node[:home]}/.emacs.d
  EOL

  not_if "test -e #{node[:home]}/.emacs.d"
end
