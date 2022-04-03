#!/bin/bash

source components/common.sh

echo -n "Configuring MongoDB Repo :"
stat $?
echo -n "Installing MongoDB : "
yum install -y mongodb-org &>> $LOGFILE

systemctl enable mongod
echo -n "Starting Mongo : "
systemctl start mongod  &>> $LOGFILE
stat $?

# 1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
  #
  #Config file: `/etc/mongod.conf`
# systemctl restart mongod


# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js

