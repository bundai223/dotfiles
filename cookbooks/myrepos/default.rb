
execute 'git clone my repos' do
  command <<-EOL
    #{sudo(node[:user])} ghq get -p bundai223/dotfiles
    #{sudo(node[:user])} ghq get -p bundai223/terminal-tools
    #{sudo(node[:user])} ghq get -p bundai223/myvim_dict
    #{sudo(node[:user])} ghq get -p bundai223/dash_snippet
    #{sudo(node[:user])} ghq get -p bundai223/mysnip
    #{sudo(node[:user])} ghq get -p bundai223/vim-template
    #{sudo(node[:user])} ghq get -p bundai223/books-zero_kara_deep_learning
    #{sudo(node[:user])} ghq get -p bundai223/blog.bundai223
    #{sudo(node[:user])} ghq get -p bundai223/bundai223.github.io
    #{sudo(node[:user])} ghq get mzyy94/RictyDiminished-for-Powerline
  EOL
end
