case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  # https://github.com/pyenv/pyenv/wiki/Common-build-problems
  include_cookbook 'git'
  dependencies = %w(
build-essential libssl-dev zlib1g-dev libbz2-dev
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev
xz-utils tk-dev libffi-dev liblzma-dev python-openssl
  )
  dependencies.each do |p|
    package p
  end

when 'opensuse'
else
end
