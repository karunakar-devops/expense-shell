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

dnf install nginx -y 
VALIDATE $? "Installing nginx"

systemctl enable nginx 
VALIDATE $? "Enabling nginx"

systemctl start nginx 
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip

cd /usr/share/nginx/html

unzip /tmp/frontend.zip

VALIDATE $? "Enabling above steps"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Copied expense conf"


systemctl restart nginx
VALIDATE $? "Restarting nginx"








