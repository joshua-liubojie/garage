#!/bin/sh

function read_input(){
    read -p "[y]/[n]" ret
    if [ $ret = "y" ]; then
        return 1
    elif [ $ret = "n" ]; then
        return 0
    fi
}

function install_apache(){
sudo yum install httpd -y
sudo sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf
sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
sudo sed -i 's/^/#&/g' /etc/httpd/conf.modules.d/00-dav.conf
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
}

function install_php(){
cd
wget https://centos7.iuscommunity.org/ius-release.rpm
sudo rpm -Uvh ius-release.rpm
sudo yum install php56u php56u-common php56u-xml php56u-gd php56u-mbstring php56u-process php56u-mysqlnd php56u-intl php56u-mcrypt php56u-imap php56u-cli -y
sudo cp /etc/php.ini /etc/php.ini.bak
sudo sed -i "s/post_max_size = 8M/post_max_size = 50M/" /etc/php.ini
sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 50M/" /etc/php.ini
sudo systemctl restart httpd.service
}

function install_mariadb(){
sudo yum install mariadb mariadb-server -y
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service
sudo /usr/bin/mysql_secure_installation
mysql -u root -p
}

function install_nextcloud(){
cd
wget https://download.nextcloud.com/server/releases/nextcloud-9.0.53.zip
sudo yum install unzip -y
unzip nextcloud-9.0.53.zip
sudo mv nextcloud/* /var/www/html && sudo chown apache:apache -R /var/www/html
cd /var/www/html/
sudo -u apache php occ maintenance:install --database "joshclouddb" --database-name "joshcloud"  --database-user "josh" --database-pass "Aa5561379" --admin-user "admin" --admin-pass "Aa5561379"
sudo find /var/www/html -type f -print0 | sudo xargs -0 chmod 0640
sudo find /var/www/html -type d -print0 | sudo xargs -0 chmod 0750
sudo chown -R root:apache /var/www/html
sudo chown -R apache:apache /var/www/html/apps
sudo chown -R apache:apache /var/www/html/config
sudo chown -R apache:apache /var/www/html/data
sudo chown -R apache:apache /var/www/html/themes
sudo chown -R apache:apache /var/www/html/updater
sudo chmod 0644 /var/www/html/.htaccess
sudo chown root:apache /var/www/html/.htaccess
sudo chmod 0644 /var/www/html/data/.htaccess
sudo chown root:apache /var/www/html/data/.htaccess
sudo chown -R apache:apache /var/www/html/assets
}

set -e

echo "Install Apache"
read_input
if [ $? -eq 1 ]; then
    install_apache
fi
echo "Install PHP and necessary PHP extensions"
read_input
if [ $? -eq 1 ]; then
    install_php
fi
echo "Install MariaDB and setup a database for NextCloud"
read_input
if [ $? -eq 1 ]; then
    install_mariadb
fi
echo "Install NextCloud"
read_input
if [ $? -eq 1 ]; then
    install_nextcloud
fi
