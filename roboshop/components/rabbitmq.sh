#!/bin/bash

source components/common.sh
COMPONENT=rabbitmq

echo -n "Installing ERLang :"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> LOGFILE
stat $?

echo -n "configuring rabbitMQ Repo :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n "Installing RabbitMQ :"
yum install rabbitmq-server -y &>> $LOGFILE
stat $?

echo -n "Starting RabbitMQ :"
systemctl enable rabbitmq-server &>> $LOGFILE
systemctl start rabbitmq-server &>> $LOGFILE
stat $?

echo -n "Creating Application User: "
rabbitmqctl list_users |grep roboshop &>> $LOGFILE
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123 &>> ${LOGFILE}
  stat $?
else
  echo "Skipping"
fi