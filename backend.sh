#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | awk -F "." '{print $1F}')
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R='\e[31m'
G='\e[32m'
Y='\e[33m'
N='\e[0m'

echo "please enter DB Password:"
read mysql_root_password

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
    echo -e  "$2..... $R Failure $N"
else
    echo -e "$2..... $G Sucess $N"
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
    useradd expense &>>$LOGFILE
else
    echo -e "user already exits..... $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE

cd /app &>>$LOGFILE

rm -rf /app/*

unzip /tmp/backend.zip

npm install

cp /home/ec2-user/expense-shell/backend.service  /etc/systemd/system/backend.service

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql client"

mysql -h db.hornet78s.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting backend"



