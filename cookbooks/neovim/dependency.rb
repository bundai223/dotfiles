include_cookbook 'ruby'
include_cookbook 'python'
#include_cookbook 'yarn'
include_cookbook 'ghq'

package 'cmake'

# ruby
# gem_package 'neovim'
execute run_as(node[:user], 'gem install neovim')

# pip =
%w[
  neovim
].each do |pip|
  # cmds =
  %w[
    pip pip3 pip2
  ].each do |pipcmd|
    execute "#{pipcmd} install --upgrade --user #{pip}" do
      user node[:user]
      only_if "which #{pipcmd}"
    end
  end
end

# pip3
%w[
  neovim-remote
].each do |pip|
  # cmds =
  execute "pip3 install --upgrade --user #{pip}" do
    user node[:user]
    only_if 'which pip3'
  end
end




# Node.js
execute 'yarn global add neovim' do
  user node[:user]
end

go_get 'github.com/tennashi/vimalter'
