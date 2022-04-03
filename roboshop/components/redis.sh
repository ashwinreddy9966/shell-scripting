#!/bin/bash
set -e
COMPONENT=redis
source components/common.sh

echo -n "configuring redis rpm repo : "
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
stat $?

echo -n "Installing Redis : "
yum install redis -y &>> $LOGFILE
stat $?

echo -n "Update Redis Config :"
if [ -f /etc/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
fi
if [ -f /etc/redis/redis.conf ] ; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
fi
stat $?

echo -n "Starting Redis : "
systemctl enable redis &>>${LOGFILE} && systemctl start redis &>>${LOGFILE}
stat $?

