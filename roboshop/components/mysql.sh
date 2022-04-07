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


# Echo removing the password validate plugin :
echo show plugins | mysql -uroot -pRoboShop@1 &>>${LOGFILE} | grep validate_password &>>${LOGFILE}
if [ $? -eq 0 ]; then
  echo -n "Uninstalling validating plugin : "
  echo 'uninstall plugin validate_password;' >/tmp/pass-validate.sql
  mysql --connect-expired-password -uroot -pRoboShop@1 </tmp/pass-validate.sql  &>>${LOGFILE}
  stat $?
fi

echo -n "Downloading the schema : "
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${LOGFILE}
stat $?

echo -n "Extracting Schema : "
cd /tmp && unzip -o mysql.zip &>>${LOGFILE}
stat $?

echo -n "Injecting Schema : "
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql  &>>${LOGFILE}
stat $?



