node.reverse_merge!(
  user: ENV['SUDO_USER'] || ENV['USER'],
)

execute "install ghq" do
  command "#{sudo(node['user'])}go get github.com/motemen/ghq"
end
