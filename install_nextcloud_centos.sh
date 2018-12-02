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
echo "In the MySQL shell, you need to create a database and a database user, and then grant privileges to this database user.
Use the following commands to finish the work. Be sure to replace the database name "nextcloud", the database username "nextclouduser", and the database user password "yourpassword" in each and every command with your own ones.
CREATE DATABASE nextcloud;
CREATE USER 'nextclouduser'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextclouduser'@'localhost' IDENTIFIED BY 'yourpassword' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;"
}

function install_nextcloud(){
cd
wget https://download.nextcloud.com/server/releases/nextcloud-9.0.53.zip
sudo yum install unzip -y
unzip nextcloud-9.0.53.zip
sudo mv nextcloud/* /var/www/html && sudo chown apache:apache -R /var/www/html
cd /var/www/html/
sudo -u apache php occ maintenance:install --database "mysql" --database-name "joshcloud"  --database-user "josh" --database-pass "Aa5561379" --admin-user "admin" --admin-pass "Aa5561379"
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
echo "Add your server IP (say it is 203.0.113.1) and domain name (say it is www.example.com) to NextCloud's trusted domains list:
sudo vi /var/www/html/config/config.php
Insert the following two lines right beneath it:
1 => '203.0.113.1',
2 => 'www.example.com',
then:
sudo systemctl restart httpd.service
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --reload"
}


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
