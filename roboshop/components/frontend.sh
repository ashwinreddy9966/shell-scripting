#!/bin/bash

source components/common.sh
echo -n "Installing Nignix : "
yum install nginx -y &>> $LOGFILE
stat $?

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

for component in catalogue user cart shipping payment; do
  echo -e "Updating Configuration"
 # sed -i -e "/${$COMPONENT}/s/localhost/${$COMPONENT}.robotlearning.internal/"  /etc/nginx/default.d/roboshop.conf
  sed -i -e "/${component}/s/localhost/${component}.robotlearning.internal/"  /etc/nginx/default.d/roboshop.conf
  stat $?
done

systemctl enable nginx
echo -n "Restarting Nginx : "
systemctl restart nginx
stat $?


