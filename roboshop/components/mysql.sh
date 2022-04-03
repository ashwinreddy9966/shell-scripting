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

echo -n "Fetching the default root password : "
grep temp /var/log/mysqld.log
# mysql_secure_installation
# mysql -uroot -pRoboShop@1
> uninstall plugin validate_password;

## **Setup Needed for Application.**

As per the architecture diagram, MySQL is needed by

- Shipping Service

So we need to load that schema into the database, So those applications will detect them and run accordingly.

To download schema, Use the following command

```bash
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
```

Load the schema for Services.