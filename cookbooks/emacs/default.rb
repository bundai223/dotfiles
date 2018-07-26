case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'aspell'
  package 'aspell-en'

  package 'emacs'
when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
when 'arch'
  package 'aspell'
  package 'aspell-en'

  package 'emacs'
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

get_repo 'kenjimyzk/spacemacs-japanese'

# spacemacs-japanese
execute "#{sudo(node[:user])} ln -s #{node[:home]}/repos/github.com/kenjimyzk/spacemacs-japanese #{node[:home]}/.config/spacemacs/layers/japanese" do
  not_if "test -L #{node[:home]}/.config/spacemacs/layers/japanese"
end

