#!/bin/bash

source components/common.sh
COMPONENT=shipping

echo -n "Installing Maven : "
yum install maven -y &>> $LOGFILE
stat $?

echo -n "Adding $FUSER User : "
USER_SETUP
stat $?

echo -n "Downloading  $COMPONENT :"
curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOGFILE}
stat $?

echo -n "CleanUp Old Content : "
rm -rf /home/${FUSER}/${COMPONENT} &>>${LOGFILE}
stat $?

echo -n "Extracting $COMPONENT"
cd /home/${FUSER} &>>${LOGFILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOGFILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOGFILE}
stat $?

echo -n "Building Artifact :"
cd shipping && mvn clean package &>>${LOGFILE} && mv target/shipping-1.0.jar shipping.jar &>>${LOG_FILE}

echo -n "Configuring SystemD : "
SVC_SETUP


#```bash
#$ cd /home/roboshop
#$ curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
#$ unzip /tmp/shipping.zip
#$ mv shipping-main shipping
#$ cd shipping
#$ mvn clean package
#$ mv target/shipping-1.0.jar shipping.jar
#```