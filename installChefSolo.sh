# Installs chef-solo
# original author: thien

sudo su
cd 
yum intall -y wget 
curl -L https://www.opscode.com/chef/install.sh | bash
wget http://github.com/opscode/chef-repo/tarball/master
tar -zxf master
mv chef-* chef-repo
rm master
cd chef-repo
mkdir .chef
echo "cookbook_path ['~/chef-repo/cookbooks']" >.chef/knife.rb

