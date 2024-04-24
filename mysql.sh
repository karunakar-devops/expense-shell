
USERID=$(id -u)

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
    echo "$2 is...... Failure"
    exit 1
else
    echo "$2 is..... Suceess"
fi
}

dnf install mysql-server -y
VALIDATE $? "Installing mysql server"

systemctl enable mysqld 
VALIDATE $? "Enabling mysql server"

systemctl start mysqld
VALIDATE $? "startting mysql server"

mysql_secure_Installation --set -root -pass ExpenseApp@1
VALIDATE $? "setting up root password"