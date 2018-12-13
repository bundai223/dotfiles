include_cookbook 'ruby'
include_cookbook 'python'
include_cookbook 'yarn'

package 'cmake'

# ruby
gem_package 'neovim'

# python
execute 'pip3 install --upgrade --user neovim' do
  user node[:user]
end
execute 'pip2 install --upgrade --user neovim' do
  user node[:user]
end

# Node.js
execute 'yarn global add neovim'
