include_recipe 'dependency.rb'

node.reverse_merge!({
  mysql: {
    major_version: 5,
    minor_version: 7,
    root_password: '',
    root_password: 'D12uM3m4y+',
  }
})

major_version = node[:mysql][:major_version]
minor_version = node[:mysql][:minor_version]

# cf) https://github.com/k0kubun/itamae-plugin-recipe-rbenv/blob/master/lib/itamae/plugin/recipe/rbenv/dependency.rb
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'mysql-server'
  package 'libmariadb-dev'

  if node[:is_wsl]
    execute 'service mysql stop'

    # file "#{node[:home]}/.bashrc" do
    #   action [:edit]
    #   block do |content|
    #     content.gsub!('sudo service mysql start', '')
    #     content << 'sudo service mysql start'
    #   end
    # end
  else
    service 'mysql' do
      action [:start, :enable]
    end
  end

when 'fedora'
  # cf) https://dev.mysql.com/downloads/repo/yum/
  package_name = "mysql#{major_version}#{minor_version}-community-release-fc27-10"
  package "https://dev.mysql.com/get/#{package_name}.noarch.rpm" do
    not_if "rpm -q #{package_name}"
  end

  package 'mysql-community-server'
  package 'mysql-community-devel'

when 'redhat', 'amazon'
  if 7 <= node['platform_version'].to_i
    execute 'remove old mariadb' do
      command 'yum remove -y mariadb-libs'
      not_if 'test $(rpm -qa | grep maria | wc -l) == "0"'
    end

    execute 'yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm'

  else
    package_name = "mysql#{major_version}#{minor_version}-community-release-el6-11"
    package "https://dev.mysql.com/get/#{package_name}.noarch.rpm" do
      not_if "rpm -q #{package_name}"
    end
  end

  package 'mysql-community-server'
  package 'mysql-community-devel'

  unless node[:is_wsl]
    service 'mysqld' do
      action [:start, :enable]
    end
  end

when 'osx', 'darwin'
when 'arch'
  package 'mysql'

  execute 'mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql' do
    not_if 'test -d /var/lib/mysql/mysql'
  end
  # execute 'mysql_secure_installation'

  unless node[:is_wsl]
    service 'mysqld' do
      action [:start, :enable]
    end
  end
when 'opensuse'
else
end

# cf) https://qiita.com/kotanbo/items/263841bae08044676c83
# MySQL初期設定
new_password = node[:mysql][:root_password]

# password空の場合
#MItamae.logger.error "new password: #{new_password}"
execute "initialize on no password" do
  user "root"
  only_if "mysql -u root -e 'show databases' | grep information_schema"

  command <<-EOL
    set -eu
    mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
    mysql -u root -e "DROP DATABASE test;"
    mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    mysqladmin password #{new_password} -u root
  EOL
end

# passwordが初期値の場合
tmp_password_cmd = %Q{grep "A temporary password is generated" /var/log/mysqld.log | sed -s 's/.*root@localhost: //'}
#MItamae.logger.error "password change: $(#{tmp_password_cmd}) -> #{new_password}"
execute "mysql_secure_installation temp password" do
  user "root"
  only_if %Q{test -e /var/log/mysqld.log && mysql -uroot -p"$(#{tmp_password_cmd})" -e 'show databases' | grep 'connect-expired-password\|information_schema'} # パスワードがtemp passwordの場合

  command <<-EOL
        mysqladmin -uroot -p"$(#{tmp_password_cmd})" password '#{new_password}'
        mysql_secure_installation -p'#{new_password}' -D
  EOL
end

execute 'mysql user add for auth_socket' do
  only_if "mysql -u root -p#{new_password} -e 'show databases' | grep information_schema"

  command <<-EOL
    set -eu
    #mysql -uroot -p'#{new_password}' -e "CREATE USER IF NOT EXISTS '#{node[:user]}'@localhost IDENTIFIED BY '#{new_password}';"
    mysql -uroot -p'#{new_password}' -e "CREATE USER IF NOT EXISTS '#{node[:user]}'@localhost IDENTIFIED VIA unix_socket;"
    mysql -uroot -p'#{new_password}' -e "GRANT ALL ON *.* TO '#{node[:user]}'@'localhost';"
  EOL
end

execute 'pip install mycli' do
  not_if 'which mycli'
end
