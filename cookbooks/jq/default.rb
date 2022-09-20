include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'jq'
when 'opensuse'
end

execute 'install jqp' do
  command <<~EOCMD
    mkdir workjqp
    pushd workjqp

    wget -q https://github.com/noahgorstein/jqp/releases/download/v0.1.0/jqp_0.1.0_Linux_x86_64.tar.gz
    tar xfz jqp_0.1.0_Linux_x86_64.tar.gz
    sudo cp jqp /usr/local/bin/jqp
    sudo chmod +x /usr/local/bin/jqp

    popd

    rm -rf workjqp
  EOCMD
end
