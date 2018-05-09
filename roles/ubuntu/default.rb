include_role('base')

# for nokogiri for rails
package 'build-essential'
package 'patch'
package 'ruby-dev'
package 'zlib1g-dev'
package 'liblzma-dev'
package 'libxml2-dev'
package 'python-fontforge'
package 'apt-file'

# locale
#package 'language-pack-ja'

execute 'locale-gen ja_JP.UTF-8'
