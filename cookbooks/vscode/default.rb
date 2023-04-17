# https://code.visualstudio.com/docs/setup/linux

case node[:platform]
when 'arch'
  include_cookbook 'yay'
  yay 'visual-studio-code-bin'

when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  execute 'add vscode repos' do
    command <<-EOL
      curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
      sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
      sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

      # おそうじ
      rm microsoft.gpg
    EOL
  end

  package 'apt-transport-https'
  execute 'apt update -y'
  package 'code'

when 'opensuse'
else
end


user = node[:user]
home = node[:home]

directory "#{home}/.config/Code" do
  owner user
end
