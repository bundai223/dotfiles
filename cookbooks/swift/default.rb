include_recipe 'dependency.rb'

case node[:platform]
when 'ubuntu'
    execute 'install swift' do
      command <<-EOL
        set -eu

        OS_MAJOR_VERSION=16
        OS_MINOR_VERSION=04
        OS_VERSION=${OS_MAJOR_VERSION}.${OS_MINOR_VERSION}
        VERSION=4.1.2

        tar=swift-${VERSION}-RELEASE-ubuntu${OS_VERSION}.tar.gz
        extract_dir=swift-${VERSION}-RELEASE-ubuntu${OS_VERSION}
        swift_path=#{node[:home]}/swift
        url=https://swift.org/builds/swift-${VERSION}-release/ubuntu${OS_MAJOR_VERSION}${OS_MINOR_VERSION}/swift-${VERSION}-RELEASE/${tar}

        wget $url
        tar fx $tar

        mv $extract_dir $swift_path
        chmod 755 -R $swift_path
        chown #{node[:user]}:#{node[:group]} -R $swift_path

        rm -f $tar
      EOL
    end

when 'debian', 'mint'
when 'redhat', 'fedora', 'amazon'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
