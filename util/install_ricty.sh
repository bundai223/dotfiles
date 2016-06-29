#!/bin/bash
 
tmpdir=/tmp/.rictywork.$$
ricty_gen='https://raw.github.com/yascentur/Ricty/master/ricty_generator.sh'
inconsolate='http://levien.com/type/myfonts/Inconsolata.otf'
migu1m='http://sourceforge.jp/frs/redir.php?m=osdn&f=%2Fmix-mplus-ipa%2F59022%2Fmigu-1m-20130617.zip'
 
# command check
for cmd in wget unzip
do
    which $cmd > /dev/null 2>&1
    [ $? != 0 ] && (echo "error: $cmd command not found."; exit 1)
done
 
dpkg -s fontforge > /dev/null 2>&1
if [ $? != 0 ]; then
    sudo apt-get -y install fontforge
    [ $? != 0 ] && (echo "error: failed to install fontforge"; exit 1)
fi
 
[ -d $tmpdir ] && \rm -fr $tmpdir
mkdir -p $tmpdir
 
# main
cd $tmpdir
 
output=ricty_generator.sh
wget -O $output $ricty_gen || ( echo "error: failed to get ricty_generator.sh"; exit 1)
chmod +x $output
 
output=Inconsolata.otf
wget -O $output $inconsolate || ( echo "error: failed to get inconsolate font"; exit 1)
 
output=`echo ${migu1m} | perl -MURI::Escape -lne 'print uri_unescape($_)'`
output=${output##*/}
wget -O $output $migu1m || ( echo "error: failed to get migu-m1 font"; exit 1 )
unzip $output
mv ${output%.*}/*.ttf .
 
echo ""
./ricty_generator.sh Inconsolata.otf migu-1m-regular.ttf migu-1m-bold.ttf
mkdir -p ~/.fonts > /dev/null 2>&1
cp -pf Ricty*.ttf ~/.fonts/
fc-cache -vf
 
\rm -fr $tmpdir
 
exit 0

