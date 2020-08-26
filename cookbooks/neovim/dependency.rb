include_cookbook 'ruby'
include_cookbook 'python'
include_cookbook 'yarn'
include_cookbook 'ghq'

package 'cmake'

# ruby
# gem_package 'neovim'
execute 'gem install --user-install neovim' do
  user node[:user]
  command <<-EOS
. /etc/profile.d/asdf.sh
gem install --user-install neovim
EOS
end

# pip =
%w[
  neovim
  neovim-remote
].each do |pip|
  # cmds =
  %w[
    pip pip3 pip2
  ].each do |pipcmd|
    execute "#{pipcmd} install --upgrade --user #{pip}" do
      user node[:user]

      command <<-EOS
. /etc/profile.d/asdf.sh
#{pipcmd} install --upgrade --user #{pip}
EOS
      only_if ". /etc/profile.d/asdf.sh; which #{pipcmd}"
    end
  end
end

# Node.js
execute 'yarn global add neovim' do
  user node[:user]
  command <<-EOS
. /etc/profile.d/asdf.sh
yarn global add neovim
EOS
end

go_get 'github.com/tennashi/vimalter'
