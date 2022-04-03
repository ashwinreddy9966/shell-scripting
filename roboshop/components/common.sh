#validating whether the user been run is ROOT or not
ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo -e "\e[33m You need to be a root user to execute this or execute this with sudo command \[0m"
  exit 1
fi

stat() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
  else
    echo -e "\e[31m Failure \e[0m"
fi
}

LOGFILE=/tmp/robot.log
