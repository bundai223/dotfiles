# cf) https://github.com/k0kubun/itamae-plugin-recipe-rbenv/blob/master/lib/itamae/plugin/recipe/rbenv/dependency.rb
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'build-essential'
  package 'dirmngr'
  package 'gpg'
  package 'curl'
when 'redhat', 'fedora', 'amazon'
  package 'gcc-c++'
  package 'make'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end

