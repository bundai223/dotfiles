include_recipe 'dependency.rb'

execute 'install awscli' do
  command <<-EOCMD
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf ./aws
  EOCMD
  not_if 'test -f /usr/local/bin/aws'
end
