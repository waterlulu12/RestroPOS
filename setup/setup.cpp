#include <iostream>
#include <mysql/mysql.h>
#include <string>
#include <sstream>
#include <fstream>
#include "billTemplate.h"

using namespace std;

#define SERVER "127.0.0.1" //Edit with your database host
#define UNAME "root" //Edit with your database username
#define PWORD "password" //Edit with your database password
#define DBNAME "newproj" //Edit with your database name
#define PORT 3306

int main()
{
    MYSQL* mysql;
    mysql = mysql_init(0);
    mysql = mysql_real_connect(mysql, SERVER, UNAME, PWORD, "", PORT, NULL, 0);
    mysql_query(mysql, "DROP DATABASE newproj");
    mysql_query(mysql, "CREATE DATABASE newproj");
    mysql = mysql_init(0);
    mysql = mysql_real_connect(mysql, SERVER, UNAME, PWORD, DBNAME, PORT, NULL, 0);
    if (mysql){

        mysql_query(mysql, "CREATE TABLE restaurant (  id int NOT NULL AUTO_INCREMENT,  name "
                           "varchar(32) NOT NULL,  contactNo varchar(10) NOT NULL,  address varchar(32) "
                           "NOT NULL, panNo varchar(9) DEFAULT NULL, serviceCharge float DEFAULT NULL, "
                           "vat float DEFAULT NULL, PRIMARY KEY (id))");

        mysql_query(mysql, "CREATE TABLE operator (  id int NOT NULL AUTO_INCREMENT,  username "
                           "varchar(16) NOT NULL,  password varchar(32) DEFAULT NULL,  "
                           "restaurantID int NOT NULL, admin tinyint(1), profileImage mediumtext,PRIMARY KEY (id), FOREIGN KEY "
                           "(restaurantID) REFERENCES restaurant (id) ON DELETE CASCADE ON UPDATE "
                           "CASCADE)");

        mysql_query(mysql, "CREATE TABLE menu_category (  id int NOT NULL AUTO_INCREMENT,  "
                           "category varchar(32) NOT NULL,  PRIMARY KEY (id))");

        mysql_query(mysql, "CREATE TABLE menu_items (  id int NOT NULL AUTO_INCREMENT,  name "
                           "varchar(32) NOT NULL,  price float NOT NULL, description text," "category int NOT NULL, discount float NOT NULL, itemImage mediumtext,  PRIMARY KEY (id),  FOREIGN KEY "
                           "(category) REFERENCES menu_category (id) ON DELETE CASCADE ON UPDATE CASCADE)");

        mysql_query(mysql,  "CREATE TABLE sales (  id int NOT NULL AUTO_INCREMENT,  customer varchar(16) "
                            "NOT NULL, totalPrice float DEFAULT NULL, discount float DEFAULT NULL,"
                            "serviceCharge float DEFAULT NULL, vat float DEFAULT NULL, oComplete "
                            "tinyint(1) NOT NULL, date date NOT NULL, time time NOT NULL, quantity "
                            "text NOT NULL, menuItems text NOT NULL, PRIMARY KEY (id))");

        mysql_query(mysql,  "CREATE TABLE bill_template (  id int NOT NULL AUTO_INCREMENT,  bill mediumtext, PRIMARY KEY (id))");
   
        
        stringstream qq;
        qq << "INSERT INTO bill_template (bill) VALUES (\"" << bills[0] << "\")";
        mysql_query(mysql, qq.str().c_str());
        
        stringstream ss;
        ss << "INSERT INTO bill_template (bill) VALUES (\"" << bills[1] << "\")";
        mysql_query(mysql, ss.str().c_str());
        
        stringstream sss;
        sss << "INSERT INTO bill_template (bill) VALUES (\"" << bills[2] << "\")";
        mysql_query(mysql, sss.str().c_str());

        string n,c,a,pan,s,v;
        cout<<"Enter Restaurant's name: ";
        cin >> n;

        stringstream oo;
        oo << "INSERT INTO restaurant (name,contactNo,address,panNo,serviceCharge,vat) VALUES (\""<< n << "\",\"0\",\"XXX\",\"XXXXXXXXX\",\"0\",\"0\");";
        mysql_query(mysql, oo.str().c_str());

        string u,p;
        cout<<"Enter Admin user's username: ";
        cin >> u;
        cout<<"Enter Admin user's password: ";
        cin >> p;

        hash<string> hasher;
        stringstream modifier;
        modifier << hasher(p);

        stringstream rr;
        rr << "INSERT INTO operator (username,password,restaurantID,admin,profileImage) VALUES (\""<< u <<"\",\""<< modifier.str() <<"\",\"1\",\"1\",\" \");";
        mysql_query(mysql, rr.str().c_str());
    }
    else{
        cout << "Not Connected";
    }
}