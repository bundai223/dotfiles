
execute 'git clone my repos' do
  command <<-EOL
    ghq get -p bundai223/init.vim
    ghq get -p bundai223/zshrc
    ghq get -p bundai223/tmux.conf
    ghq get -p bundai223/devenv
    ghq get -p bundai223/terminal-tools
    ghq get -p bundai223/zsh-utils
    ghq get -p bundai223/myvim_dict
    ghq get -p bundai223/dash_snippet
    ghq get -p bundai223/mysnip
    ghq get -p bundai223/vim-template
    ghq get -p bundai223/books-zero_kara_deep_learning
    ghq get -p bundai223/blog.bundai223
    ghq get -p bundai223/bundai223.github.io

    ghq get mzyy94/RictyDiminished-for-Powerline
  EOL
end
