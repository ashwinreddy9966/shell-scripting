#!/bin/bash

source components/common.sh
COMPONENT=shipping

echo -n "Installig Maven : "
yum install maven -y &>> $LOGFILE
stat $?

USER_SETUP
stat $?

echo -n "Downloading & Extracting $COMPONENT :"
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"  &>> $LOGFILE
unzip /tmp/shipping.zip  &>> $LOGFILE
mv /tmp/shipping-main /home/$FUSER/shipping
chown -R $FUSER:$FUSER /home/$FUSER/shipping
stat $?

cd /home/roboshop/$COMPONENT
echo "Generating the $COMPONENT Jar"
mvn clean package &>> $LOGFILE
mv target/shipping-1.0.jar shipping.jar
stat $?

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