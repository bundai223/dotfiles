include_cookbook 'yay'
yay 'cups'
yay 'ghostscript'
yay 'gsfonts'
yay 'cups-pdf'
yay 'poppler'
yay 'a2ps'

service 'org.cups.cupsd' do
  action [:enable, :start]
end


# mg7130の場合
# yay -Ss canon mg
# で検索して調べた
yay 'cnijfilter-mg7100'
