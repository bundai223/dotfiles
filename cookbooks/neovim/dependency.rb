include_cookbook 'ruby'
include_cookbook 'python'
include_cookbook 'yarn'

package 'cmake'

# ruby
# gem_package 'neovim'
execute 'gem install neovim' do
  user node[:user]
end

# python
execute 'pip3 install --upgrade --user neovim' do
  user node[:user]
  only_if 'which pip3'
end

execute 'pip2 install --upgrade --user neovim' do
  user node[:user]
  only_if 'which pip2'
end

# Node.js
execute 'yarn global add neovim'
