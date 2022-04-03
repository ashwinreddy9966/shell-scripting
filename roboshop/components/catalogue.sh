#!/bin/bash
set -e
COMPONENT=catalogue
source components/common.sh

echo -n "Configuring the RPM repo for nodeJS :"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>> ${LOGFILE}
stat $?

echo -n "Installing nodeJS : "
yum install nodejs gcc-c++ -y  &>> $LOGFILE
stat $?

echo -n "creating the $FUSER user:"
id $FUSER   &>> $LOGFILE
if [ $? -ne 0 ]; then
  useradd $FUSER
  stat $?
else
  echo -e "\e[33m $FUSER user exists , skipping \e[0m"
fi

echo -n "Downloading $1 and unzipping:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
rm -rf /home/$FUSER/$COMPONENT && cd /home/$FUSER && unzip -o /tmp/catalogue.zip &>> $LOGFILE && mv catalogue-main $COMPONENT && chown -R  $FUSER:$FUSER /home/$FUSER/$COMPONENT && cd /home/$FUSER/$COMPONENT &>> $LOGFILE
stat $?

echo -n "Installing nodejs and their packages : "
npm install &>> $LOGFILE
stat $?

#1. Updating SystemD file with correct DNS Name
echo -n "Updating the mogndodns name : "
sed -i -e "s/MONGO_DNSNAME/mongodb.robotlearning.internal"  /home/$FUSER/$COMPONENT/systemd.service
stat $?
#2. Now, lets set up the service with systemctl.

mv /home/$FUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
chown $FUSER:$FUSER /etc/systemd/system/$COMPONENT.service
echo -n "Daemon-reload : "  &>> $LOGFILE
systemctl daemon-reload  &>> $LOGFILE
stat $?

echo -n "Starting $COMPONENT"
systemctl start $COMPONENT &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
stat $?
