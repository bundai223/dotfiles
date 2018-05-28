
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  execute 'install peco binary' do
    command <<-EOL
      WORK_DIR=#{node[:home]}/work_peco
      LOCALBIN_DIR=#{node[:home]}/.local/bin

      mkdir -p $WORK_DIR
      cd $WORK_DIR

      PECO_DIR=peco_linux_amd64
      TGZ=$PECO_DIR.tar.gz
      URL=https://github.com/peco/peco/releases/download/v0.5.3/$TGZ
      curl -sOL $URL

      tar xfz $TGZ
      mv $PECO_DIR/peco $LOCALBIN_DIR/
      chown #{node[:user]}:#{node[:group]} $LOCALBIN_DIR/peco
      rm -rf $WORK_DIR
    EOL

    not_if "test -e #{node[:home]}/.local/bin/peco"
    not_if "uname -a | grep Microsoft"
  end

when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
  package 'peco'
  package 'fzf'

when 'arch'
when 'opensuse'
else
end

go_get 'github.com/mattn/cho'
