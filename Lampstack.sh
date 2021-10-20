#!/bin/bash

echo "Install HTTPD"
yum install -y httpd

echo "Start HTTPD"
systemctl start httpd.service

echo "Add Firewall Rules"
firewall-cmd --add-port 80/tcp --permanent
firewall-cmd --add-port 443/tcp --permanent

echo "Reload Firewall"
firewall-cmd --reload

echo "Enable httpd upon starup"
systemctl enable httpd.service

echo "Install mysql"
yum install -y php php-mysql

echo "Restart httpd"
systemctl restart httpd.service

echo "Php Info"
yum info-php-fpm
yum install -y phpfpm
cd /var/www/html
cat > info.php <<- EOF
<?php phpinfo(); ?>
EOF

echo "Install mariadb"
yum install -y mariadb-server mariadb

echo "Start mariadb"
systemctl start mariadb

echo "Install of mysql securities"
mysql_secure_installation <<EOF

y
A123
A123
y
y
y
y
EOF

echo "Enable mariadb upon starup"
systemctl enable mariadb 

pwd=A123

echo "Connect to mariadb"
mysqladmin -u root -p$pwd version

echo "CREATE DATABASE wordpress; CREATE USER wordpressuser@localhost IDENTIFIED by 'A123'; GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED by 'A123'; FLUSH PRIVILEGES;" | mysql -u root -p$pwd
echo "success"

echo "Install phpgd"
yum install -y php-gd

echo "Restart httpd"
systemctl restart httpd.service

echo "Install wget"
yum install -y wget

echo "Install wordpress"
wget http://wordpress.org/latest.tar.gz

echo "Zip tar"
tar xzvf latest.tar.gz

echo "Install rsync"
yum install -y rsync

echo "rsync wordpress"
rsync -avP wordpress/ /var/www/html/

cd /var/www/html/

echo "New File"
mkdir /var/www/html/wp-content/uploads

echo "chnge ownership"
chown -R apache:apache /var/www/html/*

echo "Copy files"
cp wp-config-sample.php wp-config.php

echo "Change info"
cd /var/www/html/
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/wordpressuser/g' wp-config.php
sed -i 's/password_here/A123/g' wp-config.php

echo "Install remi"
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm

echo "Install util"
yum install -y yum-utils

echo "Configs"
yum-config-manager --enable remi-php56 

echo "Install php's"
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo

echo "Restart httpd"
systemctl restart httpd.service
echo "Done!"
