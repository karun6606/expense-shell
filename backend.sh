#!/bin/bash

USERID=$(id -u)

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

}




dnf module disable nodejs -y
VALIDATE $? "Disabled nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enable nodejs:20"

dnf install nodejs -y
VALIDATE $? "Installed nodejs"

useradd expense

# id expense
# if [ $? -ne 0 ]
# then
#     useradd expense
# else
#     echo "user already exits..... SKIPPING"
# fi

# mkdir /app


# curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

# cd /app

# unzip /tmp/backend.zip

# npm install

# cp 
# C:\devops\daws-78s1\repos\expense-shell\backend.service /etc/systemd/system/backend.service

# systemctl daemon-reload

# systemctl start backend

# systemctl enable backend

# dnf install mysql -y

# mysql -h db.hornet78s.online -uroot -pExpenseApp@1 < /app/schema/backend.sql

# systemctl restart backend



