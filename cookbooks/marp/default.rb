
case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  execute 'install binary' do
    command <<-EOL
      set -eu
      name=marp
      WORK_DIR=#{node[:home]}/work_${name}
      LOCAL_DIR=#{node[:home]}/.local/bin
      version=0.0.13
      platform=linux
      arch=x64
      url=https://github.com/marp-team/marp/releases/download/v${version}/${version}-Marp-${platform}-${arch}.tar.gz

      mkdir -p $WORK_DIR
      cd $WORK_DIR

      tgz=tmp_${name}.tgz
      echo $tgz
      curl -sL -o $tgz $url

      tar xfz $tgz
      mv $WORK_DIR $LOCAL_DIR/$name
      chown -R #{node[:user]}:#{node[:group]} $LOCAL_DIR/$name
      rm -rf $LOCAL_DIR/$name/$tgz
    EOL

    not_if "test -e #{node[:home]}/.local/bin/marp"
  end

when 'osx', 'darwin'
  package 'marp'

when 'opensuse'
else
end
