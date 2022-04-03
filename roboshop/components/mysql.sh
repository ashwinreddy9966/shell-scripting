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

echo "show databases;" | mysql -uroot -pRoboShop@1 &>>${LOGFILE}
if [ $? -ne 0 ]; then
  echo -n "Changing the $COMPONENT root password"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
  DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
  mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql &>>${LOGFILE}
  stat $?
fi


# Echo removing the password validate plugin :
echo show plugins | mysql -uroot -pRoboShop@1 &>>${LOGFILE} | grep validate_password &>>${LOGFILE}
if [ $? -eq 0 ]; then
  echo " uninstall plugin validate_password;"  >/tmp/pass-validate.sql
  mysql --connect-expired-password -uroot -pRoboShop@1 </tmp/pass-validate.sql  &>>${LOGFILE}
  stat $?
fi

echo -n "Downloading the schema : "
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${LOGFILE}
stat $?

echo -n "Extracting & Injecting Schema : "
cd /tmp && unzip -o mysql.zip &>>${LOGFILE}
stat $?

echo -n "Injecting Schema : "
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql  &>>${LOGFILE}
stat $?



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