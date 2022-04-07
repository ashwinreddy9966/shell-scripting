#!/bin/bash

source components/common.sh
COMPONENT=rabbitmq

echo -n "Installing Python3 : "
yum install python36 gcc python3-devel -y &>> $LOGFILE
stat $?

USER_SETUP

DOWNLOAD_AND_INSTALL
  
echo -n "Installing Python Dependencies :"
pip3 install -r requirements.txt &>> $LOGFILE