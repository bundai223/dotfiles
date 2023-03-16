include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute 'install lazygit' do
    user node['user']

    command <<~EOCMD
      # LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/v//' )
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar xf lazygit.tar.gz lazygit
      sudo install lazygit /usr/local/bin
      rm -f lazygit*
    EOCMD
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
