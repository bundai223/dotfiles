case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'ffmpeg'
  package '7zip'
  package 'jq'
  package 'poppler-utils'
  package 'fd-find'
  package 'ripgrep'
  package 'fzf'
  package 'zoxide'
  package 'imagemagick'
when 'opensuse'
else
end
