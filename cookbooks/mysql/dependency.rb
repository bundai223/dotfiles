# cf) https://github.com/k0kubun/itamae-plugin-recipe-rbenv/blob/master/lib/itamae/plugin/recipe/rbenv/dependency.rb
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  %w[libnetcdf-dev libssl-dev libcrypto++-dev libgmp-dev ruby-dev].each do |pkg|
    package pkg
  end
when 'redhat', 'fedora', 'amazon'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end

