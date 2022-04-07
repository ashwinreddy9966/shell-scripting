#!/bin/bash

COMPONENT=$1
if [ -z "$1" ] ; then
  echo -e "\e[31m Machine Name is needed \e[0m"
  exit
fi

ZONE_ID="Z0986768G0Z9NX43SZ0Z"
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" |jq '.Images[].ImageId' | sed -e 's/"//g')
echo $AMI_ID
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=robot-allow-all |jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

create_ec2() {
PRIVATE_IP=$(aws ec2 run-instances \
                   --image-id $AMI_ID \
                   --instance-type t3.micro \
                   --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" \
                   --security-group-ids $SGID \
                   | jq '.Instances[].PrivateIpAddress' | sed 's/"//g')

sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" route53.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
}

if [ "$1" == "all" ]; then
  for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis ; do
    COMPONENT=$component
    create_ec2
  done
else
  create_ec2
fi