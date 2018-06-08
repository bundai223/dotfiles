# cf) https://github.com/k0kubun/itamae-plugin-recipe-rbenv/blob/master/lib/itamae/plugin/recipe/rbenv/dependency.rb
case node[:platform]
when 'debian', 'mint'
when 'ubuntu'
  package 'clang'
  package 'libicu-dev'
  package 'libcurl4-openssl-dev'
  package 'libssl-dev'

when 'redhat', 'fedora', 'amazon'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
