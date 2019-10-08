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

  execute 'pip3 install --upgrade --user pip setuptools wheel' do
    only_if 'which pip3'
  end

  execute 'pip2 install --upgrade --user pip setuptools wheel' do
    only_if 'which pip2'
  end

when 'osx', 'darwin'
  package 'python'

when 'arch'
  pythons = [ 'python', 'python2' ]
  packages = [ 'pip', 'setuptools', 'wheel' ]

  pythons.each do |p|
    package p

    packages.each do |pkg|
      package "#{p}-#{pkg}"
    end
  end

when 'opensuse'
  package 'python'

  execute 'pip3 install --upgrade --user pip setuptools wheel' do
    only_if 'which pip3'
  end

  execute 'pip2 install --upgrade --user pip setuptools wheel' do
    only_if 'which pip2'
  end

else
  package 'python'

  execute 'pip3 install --upgrade --user pip setuptools wheel' do
    only_if 'which pip3'
  end

  execute 'pip2 install --upgrade --user pip setuptools wheel' do
    only_if 'which pip2'
  end

end



