# frozen_string_literal: true

include_recipe 'dependency.rb'

user = node[:user]
home = node[:home]
version = "0.18.0"

url = "https://github.com/asdf-vm/asdf/releases/download/v#{version}/asdf-v#{version}-linux-amd64.tar.gz"

execute "install asdf" do
  user user
  not_if "asdf --version | grep #{version}"

  command <<EOCMD
  wget -O ./asdf.tar.gz #{url}
  pwd
  tar xfz asdf.tar.gz
  sudo mv asdf /usr/local/bin
  rm asdf.tar.gz

  asdf reshim
EOCMD
end

file "/etc/profile.d/asdf.sh" do
  content <<-EOS
# for asdf
export ASDF_DIR=~/.asdf
export ASDF_DATA_DIR=~/.asdf
export PATH="$ASDF_DATA_DIR/shims:$PATH"
EOS
  owner user
  group group
  not_if "test -e /etc/profile.d/asdf.sh"
end



# utilities
# asdfへpathとおしつつexecute
#   not_if, only_ifが予約されてるっぽいけど同じことしたいので、仕方なくアンスコ
define :source_asdf_and_execute, user: nil, not_if_: nil, not_if: nil, only_if_: nil, only_if: nil do
  cmd_ = params[:name]
  user_ = params[:user]
  not_if_ = params[:not_if] || params[:not_if_]
  only_if_ = params[:only_if] || params[:only_if_]

  execute cmd_ do
    user user_ unless user_.nil?
    not_if "#{not_if_}" unless not_if_.nil?
    only_if "#{only_if_}" unless only_if_.nil?
    command <<EOCMD
      . /etc/profile.d/asdf.sh
      #{cmd_}
EOCMD
  end
end
