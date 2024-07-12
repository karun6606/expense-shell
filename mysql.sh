#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then 
    echo "Please run with super user"
    exit 1
else
    echo "You are super user"
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e "$2.....$R Failure $N"
    else
        echo -e "$2..... $G Sucess $N"
    fi
}

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installation of myql-server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "setting root password"