
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "please enter DB Password":

read -s mysql_root_password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo "Please run with root access"
    exit 1
else
    echo "You are super user"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2----- $R Failure $N"
    else
        echo -e "$2....$G Success $N"
    fi
}


dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nodejs" 


dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enaabling nodejs" 


dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs" 


id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
     VALIDATE $? "Creating expense user"
else
    echo -e "User already exits..... $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating directory" 


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading backend code" 

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Unzipping files"

npm install 
VALIDATE $? "Installing nodejs dependencies"

cp C:\devops\daws-78s\repos-practice\expense-shell\backend.service /etc/systemd/sytem/backend.service

systemctl daemon-reload
VALIDATE $? "daemon relaod"

systemctl start backend
VALIDATE $? "Starting Backend"

systemctl enable backend
VALIDATE $? "Enabling backend"

dnf install mysql -y
VALIDATE $? "Installing client server mysql"

mysql -h db.hornet78s.online -uroot -p{mysql_root_password} < /app/schema/backend.sql
VALIDATE $? "Loading Schema"

systemctl restart backend
VALIDATE $? "restarting backend"