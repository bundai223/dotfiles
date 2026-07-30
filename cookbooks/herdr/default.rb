include_recipe 'dependency.rb'

# herdr: AIコーディングエージェント用ターミナルワークスペースマネージャ。
# https://herdr.dev/docs/install/
# バージョン更新は本体の自動更新(herdr update / herdr channel set)に任せるため、
# ここではバージョンを固定せず、未インストール時に導入するだけにする。

case node[:platform]
when 'osx', 'darwin'
  # macOSはhomebrewで入れる。
  package 'herdr'
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  # Linuxは公式インストールスクリプトで ~/.local/bin に配置する。
  execute 'install herdr' do
    user node['user']

    command 'curl -fsSL https://herdr.dev/install.sh | sh'

    not_if 'test -x ~/.local/bin/herdr || command -v herdr'
  end
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end

# herdr-browser: ペイン内にヘッドレスChromiumを描画しCDPで外部ツールから
# 操作できるようにする公式プラグイン。https://github.com/ogulcancelik/herdr-browser
# 本体のプラグイン管理(herdr plugin install)で導入する。実行にはbunが必要。
# 導入済みならplugin listに出るため再インストールしない。
execute 'install herdr-browser plugin' do
  user node['user']

  command 'herdr="$(command -v herdr || echo "$HOME/.local/bin/herdr")"; "$herdr" plugin install ogulcancelik/herdr-browser --yes'

  not_if %(herdr="$(command -v herdr || echo "$HOME/.local/bin/herdr")"; "$herdr" plugin list --plugin official.browser --json 2>/dev/null | grep -q '"plugin_id":"official.browser"')
end
