include_cookbook 'ruby'
include_cookbook 'python'
include_cookbook 'yarn'

# ruby
gem_package 'neovim'

# python
execute 'pip3 install --upgrade neovim'
execute 'pip2 install --upgrade neovim'

# Node.js
execute 'yarn global add neovim'
