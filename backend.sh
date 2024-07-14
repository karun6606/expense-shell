#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | awk -F "." '{print $1F}')
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

if [ $USERID -ne 0 ]
then    
    echo "Please run with superuser"
    exit 1 #manually exit if error occurs
else
    echo "You are superuser"
fi

VALIDATE() {
if [ $1 -ne 0 ]
then
    echo "$2..... Failure"
else
    echo "$2..... Sucess"
fi
}
dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabled nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enable nodejs:20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installed nodejs"

#useradd expense

id expense
if [ $? -ne 0 ]
then
    useradd expense
else
    echo "user already exits..... SKIPPING"
fi

mkdir /aapp

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

cd /app

#rm -rf /tmp/

unzip /tmp/backend.zip

npm install

 cp 
C:\devops\daws-78s1\repos\expense-shell\backend.service /etc/systemd/system/backend.service

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql client"

mysql -h db.hornet78s.online -uroot -pExpenseApp@1 < /app/schema/backend.sql

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting backend"



