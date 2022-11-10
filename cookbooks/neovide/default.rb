include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute 'install neovide from binaries.' do
    command <<~EOCMD
      WORKDIR=work_neovide
      mkdir "${WORKDIR}"
      pushd "${WORKDIR}"

      wget https://github.com/neovide/neovide/releases/download/0.10.3/neovide.tar.gz
      tar xfz neovide.tar.gz
      mv neovide /usr/local/bin/

      popd
      rm -rf "${WORKDIR}"
    EOCMD
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
