
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Please enter DB Password:"
read  mysql_root_password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ $USERID -ne 0 ]
then 
    echo "Please run this script with root access"
    exit 1
else
    echo "You are Super User"
fi

VALIDATE(){
if [ $1 -ne 0 ]
then 
    echo -e "$2 is......$R Failure $N"
    exit 1
else
    echo -e "$2 is..... $G Suceess $N"
fi
}

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "startting mysql server"

#mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOGFILE
#VALIDATE $? "setting up root password"

mysql -h db.hornet78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "setting up root password"

else
    echo -e "Already password set..... $Y SKIPPING $N"
fi
