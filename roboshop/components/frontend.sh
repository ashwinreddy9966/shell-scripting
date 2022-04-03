#!/bin/bash

#validating whether the user been run is ROOT or not
ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo -e "\e[33m You need to be a root user to execute this or execute this with sudo command \[0m"
  exit 1
fi

stat() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
  else
    echo -e "\e[31m Failure \e[0m"
fi
}

LOGFILE=/tmp/$1.sh

echo -n "Installing Nignix : "
yum install nginx -y &>> $LOGFILE
stat $?

 systemctl enable nginx &>> $LOGFILE

 systemctl start nginx  &>> $LOGFILE
 echo -n "Downloading Frontend : "
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $LOGFILE
 stat $?

 cd /usr/share/nginx/html
 rm -rf *
 echo -n "Extracting the frontend"
 unzip /tmp/frontend.zip &>> $LOGFILE
 stat $?

 mv frontend-main/* .
 mv static/* .
 rm -rf frontend-main README.md
 echo -n "Configuring the nginx config : "
 mv localhost.conf /etc/nginx/default.d/roboshop.conf
 stat $?

systemctl enable nginx
echo -n "Restarting Nginx : "
systemctl restart nginx
stat $?
