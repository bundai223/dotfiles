# mo: Markdown viewer that opens .md files in a browser (https://github.com/k1LoW/mo)
include_recipe 'dependency.rb'

version = '1.5.6' # 空文字にすると最新を取得する

case node[:platform]
when 'osx', 'darwin'
  execute 'install mo' do
    user node['user']
    command 'brew install k1LoW/tap/mo'
    not_if 'which mo'
  end

when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon', 'arch'
  execute 'install mo' do
    user node['user']

    command <<~EOCMD
      set -eu
      MO_VERSION=#{version}
      test -z "$MO_VERSION" && MO_VERSION=$(curl -s "https://api.github.com/repos/k1LoW/mo/releases/latest" | jq -r '.tag_name' | sed 's/v//') # version未設定だったら最新を取得する

      case "$(uname -m)" in
        x86_64|amd64) ARCH=amd64 ;;
        aarch64|arm64) ARCH=arm64 ;;
        *) echo "unsupported arch: $(uname -m)" >&2; exit 1 ;;
      esac

      WORK_DIR=$(mktemp -d)
      cd "$WORK_DIR"
      curl -Lo mo.tar.gz "https://github.com/k1LoW/mo/releases/download/v${MO_VERSION}/mo_v${MO_VERSION}_linux_${ARCH}.tar.gz"
      tar xf mo.tar.gz mo
      sudo install mo /usr/local/bin
      cd /
      rm -rf "$WORK_DIR"
    EOCMD

    not_if "mo --version 2>/dev/null | grep -qF '#{version}'"
  end

when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
