#! /bin/bash
cd /etc/fonts/conf.d/
sudo mv 65-droid-sans-fonts.conf 65-droid-sans-fonts.conf.bak
sudo fc-cache -s -f -v /usr/share/fonts/truetype/droid/
sudo mv 65-droid-sans-fonts.conf.bak 65-droid-sans-fonts.conf
