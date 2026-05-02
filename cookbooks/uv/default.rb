user = node[:user]
home = node[:home]

case node[:platform]
when 'arch'
  package 'uv'
when 'osx', 'darwin'
  package 'uv'
else
  directory "#{home}/.local" do
    owner user
    group node[:group]
  end

  directory "#{home}/.local/bin" do
    owner user
    group node[:group]
  end

  execute 'install uv' do
    user user
    command <<-EOCMD
      curl -LsSf https://astral.sh/uv/install.sh | sh
    EOCMD
    not_if "test -x #{home}/.local/bin/uv || which uv"
  end
end
