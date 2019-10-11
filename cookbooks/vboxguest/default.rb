# for archlinux
package 'virtualbox-guest-modules-arch'
package 'virtualbox-guest-utils'

service 'vboxservice' do
  action [:start,:enable]
end

group 'vboxsf' do
  user node[:user]
end
