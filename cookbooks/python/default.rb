
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'python-dev'
  package 'python-pip'
  package 'python3-dev'
  package 'python3-pip'

when 'fedora', 'redhat'
  package 'python'

when 'amazon'
  package 'python'

when 'osx', 'darwin'
  package 'python'

when 'arch'
  package 'python'

when 'opensuse'
  package 'python'

else
  package 'python'

end


execute 'install python package' do
  command <<-EOL
    pip3 install --upgrade pip setuptools wheel
    pip install --upgrade pip setuptools wheel
  EOL
end
