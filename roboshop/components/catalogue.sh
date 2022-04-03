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

echo -n "Downloading $1 :"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
stat $?

cd /home/$FUSER
echo -n "Unzipping $COMPONENT : "
unzip -o /tmp/catalogue.zip  &>> $LOGFILE
stat $?

mv -f catalogue-main $COMPONENT
cd /home/$FUSER/$COMPONENT
echo -n "Intalling nodejs and their packages : "
npm install&>> $LOGFILE
stat $?


#1. Update SystemD file with correct IP addresses
#
#    Update `MONGO_DNSNAME` with MongoDB Server IP
#
#2. Now, lets set up the service with systemctl.
#
## mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
## systemctl daemon-reload
## systemctl start catalogue
## systemctl enable catalogue
