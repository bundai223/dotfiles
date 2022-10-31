
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'fzf'

  # package 'peco'
  execute 'install peco' do
    command <<~EOCMD
      mkdir work_peco
      pushd work_peco

      wget https://github.com/peco/peco/releases/download/v0.5.10/peco_linux_amd64.tar.gz
      tar xfz peco_linux_amd64.tar.gz
      sudo cp peco_linux_amd64/peco /usr/bin/
      popd

      rm -rf work_peco
    EOCMD

    not_if 'which peco'
  end
when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
  package 'peco'
  package 'fzf'

when 'arch'
  include_cookbook 'yay'

  yay 'peco'
when 'opensuse'
else
end

