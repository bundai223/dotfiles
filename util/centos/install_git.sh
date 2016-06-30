sudo yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel

wget https://www.kernel.org/pub/software/scm/git/git-2.9.0.tar.xz
tar xf git-2.9.0.tar.xz
cd git-2.9.0
make prefix=/usr/local all
sudo make prefix=/usr/local/install

# TODO: なにかperlのライブラリが不足していてインストールが完了しない
