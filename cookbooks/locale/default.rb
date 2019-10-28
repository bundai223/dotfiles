locale = 'ja_JP.UTF-8'

include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  file '/etc/locale.gen' do
    action :edit
    not_if "localectl list-locales | grep #{locale}"
    block do |content|
      content.gsub!("##{locale}", locale)
    end
  end

  execute 'locale-gen' do
    not_if "localectl list-locales | grep #{locale}"
  end

  execute "localectl set-locale #{locale}" do
    not_if "localectl status | grep Locale | grep #{locale}"
  end

when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
