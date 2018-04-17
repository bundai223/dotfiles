
package 'python'

execute 'install python package' do
  command <<-EOL
    pip3 install --upgrade pip setuptools wheel
    pip install --upgrade pip setuptools wheel
  EOL
end
