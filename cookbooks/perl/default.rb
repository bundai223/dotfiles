include_recipe 'dependency.rb'
execute 'cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)'
execute 'cpanm JSON'
execute 'cpanm LWP::Simple LWP::Protocol::https'
