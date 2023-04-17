# frozen_string_literal: true

include_recipe 'dependency.rb'

user = node[:user]
home = node[:home]

execute "git clone https://github.com/asdf-vm/asdf.git #{home}/.asdf" do
  user user
  not_if "test -e #{home}/.asdf"
end

file '/etc/profile.d/asdf.sh' do
  content <<EOCONTENT
  export ASDF_DIR=~/.asdf
  source ~/.asdf/asdf.sh
EOCONTENT
  not_if 'test -e /etc/profile.d/asdf.sh'
  mode '644'
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
    not_if "source /etc/profile.d/asdf.sh && #{not_if_}" unless not_if_.nil?
    only_if "source /etc/profile.d/asdf.sh && #{only_if_}" unless only_if_.nil?
    command <<EOCMD
      source /etc/profile.d/asdf.sh
      #{cmd_}
EOCMD
  end
end
