#!/bin/bash

source components/common.sh
COMPONENT=shipping

MAVEN 

 echo -n "Downloading  $COMPONENT :"
 curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOGFILE}
 stat $?

USER_SETUP

 echo -n "CleanUp Old Content : "
 rm -rf /home/${FUSER}/${COMPONENT} &>>${LOGFILE}
 stat $?

 echo -n "Extracting $COMPONENT"
 cd /home/${FUSER} &>>${LOGFILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOGFILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOGFILE}
 stat $?

 echo -n "Building Artifact :"
 cd shipping && mvn clean package &>>${LOGFILE} && mv target/$COMPONENT-1.0.jar $COMPONENT.jar &>>${LOGFILE}

# echo -n "Configuring SystemD : "
SVC_SETUP


