
case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  unless node[:is_wsl]
    execute 'install peco binary' do
      command <<-EOL
        VERSION=0.5.3
        WORK_DIR=#{node[:home]}/work_peco
        LOCALBIN_DIR=#{node[:home]}/.local/bin

        mkdir -p $WORK_DIR
        cd $WORK_DIR

        PECO_DIR=peco_linux_amd64
        TGZ=$PECO_DIR.tar.gz
        URL=https://github.com/peco/peco/releases/download/v${VERSION}/$TGZ
        curl -sOL $URL

        tar xfz $TGZ
        mv $PECO_DIR/peco $LOCALBIN_DIR/
        chown #{node[:user]}:#{node[:group]} $LOCALBIN_DIR/peco
        rm -rf $WORK_DIR
      EOL

      not_if "test -e #{node[:home]}/.local/bin/peco"
    end
  end

when 'osx', 'darwin'
  package 'peco'
  package 'fzf'

when 'arch'
  include_cookbook 'yay'

  yay 'peco'
when 'opensuse'
else
end

go_get 'github.com/mattn/cho'
