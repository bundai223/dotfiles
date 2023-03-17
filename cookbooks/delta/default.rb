include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError

when 'debian', 'ubuntu', 'mint'
  execute 'install delta' do
    user node['user']

    command <<~EOCMD
      VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | jq -r '.tag_name' | sed 's/v//' )
      curl -Lo delta.tar.gz "https://github.com/dandavison/delta/releases/latest/download/delta-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"
      tar xf delta.tar.gz delta-${VERSION}-x86_64-unknown-linux-gnu/delta
      sudo install delta-${VERSION}-x86_64-unknown-linux-gnu/delta /usr/local/bin
      rm -rf delta*
    EOCMD
  end

when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
