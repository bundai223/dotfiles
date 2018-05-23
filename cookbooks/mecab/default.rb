
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'mecab'
  package 'libmecab-dev'
  package 'mecab-ipadic'
  package 'mecab-ipadic-utf8'

when 'fedora', 'redhat', 'amazon'
  execute 'install mecab repos' do
    command <<-EOL
      yum localinstall -y http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
    EOL
    not_if 'test -e /etc/yum.repos.d/groonga.repo'
  end

  package 'mecab'
  package 'mecab-ipadic'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
