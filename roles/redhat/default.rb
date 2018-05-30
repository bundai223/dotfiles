execute 'yum update -y'

package 'wget'
package 'unzip'
package 'vim'
package 'gcc'

include_role 'base'
include_cookbook 'mysql'
include_cookbook 'nodejs'
include_cookbook 'yarn'

package 'mecab'

execute 'localedef -f UTF-8 -i ja_JP /usr/lib/locale/ja_JP.UTF-8'
