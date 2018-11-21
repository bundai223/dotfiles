
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'python-dev'
  package 'python-pip'
  package 'python3-dev'
  package 'python3-pip'

when 'fedora', 'redhat'
  package 'https://centos7.iuscommunity.org/ius-release.rpm' do
    not_if 'test -e /etc/yum.repos.d/ius.repo'
  end
  package 'python'
  package 'python36u'
  package 'python36u-libs'
  package 'python36u-devel'
  package 'python36u-pip'

  execute 'ln -s /usr/bin/python3.6 /usr/bin/python3' do
    not_if 'test -e /usr/bin/python3'
  end
  execute 'ln -s /usr/bin/pip3.6 /usr/bin/pip3' do
    not_if 'test -e /usr/bin/pip3'
  end

when 'amazon'
  package 'python'
  package 'python3'

when 'osx', 'darwin'
  package 'python'

when 'arch'
  package 'python'
  package 'python2'
  package 'python-pip'
  package 'python2-pip'

when 'opensuse'
  package 'python'

else
  package 'python'

end


execute 'install python package' do
  command <<-EOL
    pip3 install --upgrade pip setuptools wheel
    pip2 install --upgrade pip setuptools wheel
  EOL
end
