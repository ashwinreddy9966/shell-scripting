#!/bin/bash
set -e
COMPONENT=redis
source components/common.sh

echo -n "configuring redis rpm repo : "
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?

echo -n "Installing Redis : "
yum install redis -y &>> $LOGFILE

