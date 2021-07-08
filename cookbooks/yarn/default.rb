include_cookbook 'nodejs'
include_cookbook 'asdf'

case node[:platform]
when 'debian', 'ubuntu', 'mint'
  source_asdf_and_execute 'npm install --global yarn' do
    user node[:user]
    not_if 'which yarn'
  end

when 'fedora', 'redhat', 'amazon'
  source_asdf_and_execute 'npm install --global yarn' do
    user node[:user]
    not_if 'which yarn'
  end

when 'osx', 'darwin'
when 'arch'
  source_asdf_and_execute 'npm install --global yarn' do
    user node[:user]
    not_if 'which yarn'
  end

when 'opensuse'
else
end

remote_file '/etc/profile.d/yarn.sh' do
  source 'files/yarn.sh'
  mode '644'
end

# # ほんとうはここじゃないが書くところないのでここで・・・
# execute 'yarn global add bash-language-server'
# execute 'yarn global add dockerfile-language-server-nodejs'
# execute 'yarn global add vue-language-server'
# execute 'yarn global add vscode-json-languageserver-bin'
# execute 'yarn global add vscode-css-languageserver-bin'
# execute 'yarn global add vscode-html-languageserver-bin'
# execute 'yarn global add yaml-language-server'
# execute 'yarn global add vim-language-server'
# execute 'yarn global add eslint-plugin-vue'
