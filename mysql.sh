#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ USERID -ne 0 ]
then 
    echo "Please run with super user"
    exit 1
else
    echo "You are super user"
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo "$2..... Failure"
    else
        echo "$2..... Sucess"
    fi
}

dnf install mysql-server -y
VALIDATE $? "Installation of myql-server"

systemctl enable mysqld
VALIDATE $? "Enabling mysql"

systemctl start mysqld
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "setting root password"