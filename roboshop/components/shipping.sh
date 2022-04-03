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

echo "CleanUp Old Content"
rm -rf /home/${FUSER}/${COMPONENT} &>>${LOGFILE}
stat $?

echo -n "Extracting $COMPONENT"
cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}

# cd /home/roboshop/$COMPONENT
# echo "Generating the $COMPONENT Jar"
# mvn clean package &>> $LOGFILE
# mv target/shipping-1.0.jar shipping.jar
# stat $?

# echo -n "Configuring SystemD : "
# SVC_SETUP
# stat $?

#```bash
#$ cd /home/roboshop
#$ curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
#$ unzip /tmp/shipping.zip
#$ mv shipping-main shipping
#$ cd shipping
#$ mvn clean package
#$ mv target/shipping-1.0.jar shipping.jar
#```