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

echo "Install Apache"
read_input
if [ $? -eq 1 ]; then
    install_apache
fi
