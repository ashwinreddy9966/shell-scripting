#validating whether the user been run is ROOT or not
ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo -e "\e[33m You need to be a root user to execute this or execute this with sudo command \[0m"
  exit 1
fi

FUSER=roboshop
LOGFILE="/tmp/robot.log"

stat() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
  else
    echo -e "\e[31m Failure \e[0m"
fi
}

USER_SETUP() {
  id ${FUSER} &>> ${LOGFILE}
  if [ $? -ne 0 ]; then
    echo -n "Adding Application User"
    useradd ${FUSER} &>>${LOGFILE}
    stat $?
  fi
}

DOWNLOAD_AND_INSTALL() {
  echo -n "Downloading $COMPONENT and unzipping:"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
  rm -rf /home/$FUSER/$COMPONENT && cd /home/$FUSER && unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE && mv ${COMPONENT}-main $COMPONENT && chown -R  $FUSER:$FUSER /home/$FUSER/$COMPONENT && cd /home/$FUSER/$COMPONENT &>> $LOGFILE
  stat $?
}

SVC_SETUP() {
  #1. Updating SystemD file with correct DNS Name
  echo -n "Updating the $COMPONENT DNS name : "
  sed -i  -e 's/MONGO_DNSNAME/mongodb.robotlearning.internal/' \
          -e 's/REDIS_ENDPOINT/redis.robotlearning.internal/' \
          -e 's/MONGO_ENDPOINT/mongodb.robotlearning.internal/' \
          -e 's/CATALOGUE_ENDPOINT/catalogue.robotlearning.internal/' \
          -e 's/CARTENDPOINT/cart.robotlearning.internal/' \
          -e 's/DBHOST/mysql.robotlearning.internal/' \
          -e 's/CARTHOST/cart.robotlearning.internal/' \
          -e 's/USERHOST/user.robotlearning.internal/' \
          -e 's/AMQPHOST/rabbitmq.robotlearning.internal/' \
          /home/roboshop/${COMPONENT}/systemd.service &>>${LOGFILE}
  stat $?

  #2. Now, lets set up the service with systemctl.
  echo -n "Aligning $COMPONENT ownership to $FUSER"
  chown -P $FUSER:$FUSER /home/$FUSER/$COMPONENT
  mv /home/$FUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
  chown $FUSER:$FUSER /etc/systemd/system/$COMPONENT.service
  echo -n "Daemon-reload : "  &>> $LOGFILE &&  systemctl daemon-reload  &>> $LOGFILE
  stat $?

  echo -n "Retarting $COMPONENT"
  systemctl restart $COMPONENT &>> $LOGFILE && systemctl enable $COMPONENT &>> $LOGFILE
  stat $?
}

#NODEJS_FUNCTION
NODEJS() {
  echo -n "Configuring the RPM repo for nodeJS :"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>> ${LOGFILE}
  stat $?

  echo -n "Installing nodeJS : "
  yum install nodejs gcc-c++ -y  &>> $LOGFILE
  stat $?

  USER_SETUP
  
  DOWNLOAD_AND_INSTALL

  echo -n "Downloading nodejs packages and dependencies: "
  npm install &>> $LOGFILE
  stat $?

}

# DOWNLOAD_EXTRACT(){
# echo -n "Downloading $COMPONENT component"
# curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOGFILE}
# stat $?

# # echo -n "CleanUp Old Content : "
# # rm -rf /home/${FUSER}/${COMPONENT} &>>${LOGFILE}
# # stat $?

# echo -n "Extracting $COMPONENT"
# cd /home/${FUSER} &>>${LOGFILE}  && unzip -o /tmp/${COMPONENT}.zip &>>${LOGFILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOGFILE}
# stat $?

# }


MAVEN(){
  echo -n "Installing Maven : "
  yum install maven -y &>> $LOGFILE
  stat $?
  
  # Configures and add user
  USER_SETUP
}