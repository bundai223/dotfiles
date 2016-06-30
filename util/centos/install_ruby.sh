#! /bin/sh
# rootで実行すること

# 環境変数
cp ./rbenv.sh /etc/profile.d/
source /etc/profile.d/rbenv.sh

# default gems
cp ./default-gems /usr/local/rbenv/

yum -y install git sqlite sqlite-devel httpd-devel curl-devel apr-devel apr-util-devel libffi-devel openssh openss openssl-devel readline-devel zlib-devel libcurl-devel

# rbenv
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
mkdir rbenv/shims rbenv/versions rbenv/plugins
groupadd rbenv
chgrp -R rbenv rbenv
chmod -R g+rwxXs rbenv

# ruby-build
cd /usr/local/rbenv/plugins

git clone git://github.com/sstephenson/ruby-build.git ruby-build
chgrp -R rbenv ruby-build
chmod -R g+rwxs ruby-build

# rbenv-default-gems
git clone git://github.com/sstephenson/rbenv-default-gems.git rbenv-default-gems
chgrp -R rbenv rbenv-default-gems
chmod -R g+rwxs rbenv-default-gems

# install ruby
rbenv install 2.3.1
rbenv global 2.3.1

# rails
gem install rails --no-ri --no-doc
