sudo yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker

WORK_DIR=/tmp
cd ${WORK_DIR}
wget https://www.kernel.org/pub/software/scm/git/git-2.9.0.tar.xz
tar xf git-2.9.0.tar.xz
cd git-2.9.0
./configure prefix=/usr/local
make all
sudo make install
