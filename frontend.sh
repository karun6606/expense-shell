#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | awk -F "." '{print 1F}')
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R='\e[31m'
G='\e[32m'
Y='\e[33m'
N='\e[0m'

if [ $USERID -ne 0 ]
then    
    echo "Please run with super user"
    exit 1 # manually exists if error occurs
else
    echo "You are super user"
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2..... $R FAILURE $N"
    else
        echo -e "$2..... $G SUCCESS $N"
    fi
}

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installed nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabled nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Started nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing code "

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloaded frontend code"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzipping frontend code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copying code"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"

