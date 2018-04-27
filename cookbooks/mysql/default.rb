include_recipe 'dependency.rb'

node.reverse_merge!({
  mysql: {
    major_version: 5,
    minor_version: 7,
    root_password: ''
  }
})

major_version = node[:mysql][:major_version]
minor_version = node[:mysql][:minor_version]

# cf) https://github.com/k0kubun/itamae-plugin-recipe-rbenv/blob/master/lib/itamae/plugin/recipe/rbenv/dependency.rb
case node[:platform]
when 'debian', 'ubuntu', 'mint'
when 'fedora'
  # cf) https://dev.mysql.com/downloads/repo/yum/
  package_name = "mysql#{major_version}#{minor_version}-community-release-fc27-10"
  package "https://dev.mysql.com/get/#{package_name}.noarch.rpm" do
    not_if "rpm -q #{package_name}"
  end

  package 'mysql-community-server'
  package 'mysql-community-devel'
when 'redhat', 'amazon'
  package_name = "mysql#{major_version}#{minor_version}-community-release-el6-11"
  package "https://dev.mysql.com/get/#{package_name}.noarch.rpm" do
    not_if "rpm -q #{package_name}"
  end

  package 'mysql-community-server'
  package 'mysql-community-devel'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end

service 'mysqld' do
  action [:start, :enable]
end

# cf) https://qiita.com/kotanbo/items/263841bae08044676c83
# MySQL初期設定
new_password = node[:mysql][:root_password]

# password空の場合
execute "mysql_secure_installation no password" do
    user "root"
    only_if "mysql -u root -e 'show databases' | grep information_schema" # パスワードが空の場合
    command <<-EOL
        mysqladmin -u root password #{new_password}
        mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='';"
        mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
        mysql -u root -ppassword -e "DROP DATABASE test;"
        mysql -u root -ppassword -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
        mysql -u root -ppassword -e "FLUSH PRIVILEGES;"
    EOL
end

# passwordが初期値の場合
check_temp_password_result = run_command(%Q{grep "A temporary password is generated" /var/log/mysqld.log | sed -s 's/.*root@localhost: //'})
if check_temp_password_result.exit_status == 0
  temp_password = check_temp_password_result.stdout.chomp

  execute "mysql_secure_installation temp password" do
      user "root"
      only_if "mysql -uroot -p'#{temp_password}' -e 'show databases' | grep information_schema" # パスワードがtemp passwordの場合
      command <<-EOL
          mysqladmin -uroot -p'#{temp_password}' password '#{new_password}'
          mysql_secure_installation -p'#{new_password}' -D
      EOL
  end
end

