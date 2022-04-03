#!/bin/bash

source components/common.sh

echo -n "Configuring MongoDB Repo :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
stat $?
echo -n "Installing MongoDB : "
yum install -y mongodb-org &>> $LOGFILE

systemctl enable mongod
echo -n "Starting Mongo : "
systemctl start mongod  &>> $LOGFILE
stat $?

# Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
echo -n "Updating the mongo proxt config file : "
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf
stat $?

echo -n "Restart Mongo : "
systemctl restart mongod

echo -n "Downloading the schema : "
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
stat $?

cd /tmp && unzip mongodb.zip &>> $LOGFILE  && cd mongodb-main
echo -n "Injecting the schema : "
mongo < catalogue.js &>> $LOGFILE  && mongo < users.js &>> $LOGFILE
stat $?

