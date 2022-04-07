#!/bin/bash

source components/common.sh
COMPONENT=payment

echo -n "Installing Python3 : "
yum install python36 gcc python3-devel -y &>> $LOGFILE
stat $?

USER_SETUP

DOWNLOAD_AND_INSTALL
  
echo -n "Installing Python Dependencies :"
pip3 install -r requirements.txt &>> $LOGFILE
stat $?

echo "Update Application Config payment.ini"
USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)
sed -i -e "/uid/ c uid = ${USER_ID}" -e "/gid/ c gid = ${GROUP_ID}" ${COMPONENT}.ini
stat $?

SVC_SETUP