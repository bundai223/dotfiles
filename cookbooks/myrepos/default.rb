

myrepos = [
  'bundai223/dotfiles',
  'bundai223/terminal-tools',
  'bundai223/myvim_dict',
  'bundai223/dash_snippet',
  'bundai223/mysnip',
  'bundai223/vim-template',
  'bundai223/books-zero_kara_deep_learning',
  'bundai223/blog.bundai223',
  'bundai223/bundai223.github.io',
  'gitlab.com:bundai223/RictyDiminished-for-Powerline',
  'gitlab.com:bundai223/private-memo.git',
]
myrepos.each {|name| get_repo name}
