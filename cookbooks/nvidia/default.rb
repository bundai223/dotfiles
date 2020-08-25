include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  # https://wiki.manjaro.org/index.php?title=Configure_NVIDIA_(non-free)_settings_and_load_them_on_Startup
  execute 'mhwd -a pci nonfree 0300'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end

