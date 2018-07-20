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
    U=#{node[:user]}
    G=#{node[:group]}
    UH=#{node[:home]}
    git clone https://github.com/syl20bnr/spacemacs $UH/.emacs.d
    chown $U:$G -R $UH
  EOL

  not_if "test -e #{node[:home]}/.emacs.d"
end
