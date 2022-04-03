#!/bin/bash

source components/common.sh
COMPONENT=mysql

echo -n "Configuring mysql repo :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
stat $?

echo -n "Installing MySQL Community Edition :"
yum install mysql-community-server -y   &>>${LOGFILE}
stat $?

echo -n "Starting MySQL Server : "
systemctl enable mysqld &>>${LOGFILE}
systemctl start mysqld &>>${LOGFILE}
stat $?

#echo -n "Fetching the default root password : "
#DEFAULT_ROOT_PASSWORD=$(sudo grep temp /var/log/mysqld.log | head -n 1 |  awk -F " " '{print $NF}')

echo -n "show databases;" | mysql -uroot -pRoboShop@1
if [ $? -ne 0]; then
  echo "Changing the $COMPONENT root password"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
  DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
  mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql &>>${LOGFILE}
  stat $?
fi


## mysql_secure_installation
## mysql -uroot -pRoboShop@1
#> uninstall plugin validate_password;
#
### **Setup Needed for Application.**
#
#As per the architecture diagram, MySQL is needed by
#
#- Shipping Service
#
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
#```bash
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#```
#
#Load the schema for Services.