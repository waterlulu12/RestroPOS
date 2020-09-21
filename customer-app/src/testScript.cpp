#include <iostream>
#include <mysql/mysql.h>
#include "utils.h"
#include <string>
#include <sstream>
#include <fstream>
using namespace std;
#define SERVER "127.0.0.1"
#define UNAME "root"
#define PWORD "password"
#define DBNAME "project"
#define PORT 3306

int main()
{
    MYSQL* mysql;
    mysql = mysql_init(0);
    mysql = mysql_real_connect(mysql, SERVER, UNAME, PWORD, "", PORT, NULL, 0);
    mysql_query(mysql, "DROP DATABASE project");
    mysql_query(mysql, "CREATE DATABASE project");
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
   
        Base64 b("bill.xls",Base64::FileMode);
        
        stringstream qq;
        qq << "INSERT INTO bill_template (bill) VALUES (\"" << b.encode() << "\")";
        mysql_query(mysql, qq.str().c_str());
        
        Base64 c("bill2.xls",Base64::FileMode);
        
        stringstream ss;
        ss << "INSERT INTO bill_template (bill) VALUES (\"" << c.encode() << "\")";
        mysql_query(mysql, ss.str().c_str());
        
        Base64 f("bill3.xls",Base64::FileMode);
        
        stringstream sss;
        sss << "INSERT INTO bill_template (bill) VALUES (\"" << f.encode() << "\")";
        mysql_query(mysql, sss.str().c_str());

        string cat[10] = {"Thakali Snacks","Nepali Snacks","MO:MO","Pizza","Continental(Snacks)","Continental(SALAD)","A-LA-CARTE","BURGER & SANDWICH","WRAPS","Spaghetti & Penne"};
        int catI[10] = {14,15,6,4,9,3,14,5,2,5};
        string its[77] = {"Aloo Simi Jimbu","Bhuteko Masu (Mutton)","Bhuteko Masu (Chicken)","Chicken Sukuti Bhuteko","Chicken Sukuti Fry","Chicken Sukuti Sandheko","Grilled Potato","Gundruk Ko Achar","Kanchamb (Phapar Ko Chips)","Katohn (Ragat Ko Sausage)","Mula Ko Achar","Pangra Bhuteko","Pangra Fry","Tittey Karela Ko Achar","Plain Peanut","Aalu Sandheko","Beans Sprout Sandheko","Chicken Sandheko","Crispy Corn ","Green Salad (N/S)","Grilled Garlic","Masala Papad","Paneer Pakoda","Papad","Peanut Sandheko","Phapar ko Chips Chilly","Piro Aloo","Popcorn","Sauteed Mix Vegetables","Chicken ' C ' Mo:Mo","Chicken Kothey Mo:Mo","Chicken Steam Mo:Mo","Paneer Veg ' C ' Mo:Mo","Paneer Veg. Kothey Mo:Mo","Paneer Veg. Steam Mo:Mo","Cheese Pizza","Chicken Pizza","Margarita Pizza","Mixed Pizza","Cheese Ball","Cheesy Nachos Veg","Chicken Meat Ball","Chicken Satay","Chicken Wings","French Fries","Gnocchi Panna","Nachos Veg","Stuffed Mushroom","Fresh Organic Garden Salad","Smoked Chicken Salad","Tomato & Mozzarella Cheese Salad","Boiled Rice (Usina Chamal)","Brown,Rice","Chicken Curry","Chyangra Sukuti Fry","Daal","Gundruk Ko Jhol","Mixed Veg. Curry","Mutton Curry","Phapar ko Roti","Saag","Steamed Rice","Tom Yam Soup (Chicken)","Tom Yam Soup (Shrimp)","Tom Yam Soup (Veg)","Alice Special Club Sandwich","Fried Chicken Burger","Grilled Chicken Burger","Veg. Mushroom Burger","Veg-Cheese Sandwich","BBQ Chicken Wrap","Paneer Wrap", "Penne Arrabbiata","Salsa Di Tonno","Spaghetiti Pomodoro","Spaghetti Carbonara","Spaghetti Peperocino"};
        string price[77] = {"195.00","425.00","365.00","395.00","355.00","395.00","240.00","95.00","175.00","285.00","95.00","265.00","235.00","145.00","225.00","225.00","345.00","250.00","175.00","145.00","125.00","295.00","75.00","185.00","295.00","225.00","95.00","245","365.00","310.00","275.00","325.00","275.00","245.00","400.00","445.00","400.00","465.00","345.00 ","350.00","345.00 ","385.00", "345.00","175.00","385.00","300.00","295.00","295.00","400.00","325.00","95.00","95.00","325.00","555.00","185.00","185.00","175.00","395.00","90.00","115.00","95.00","95.00","465.00","'535.00'","325.00","450.00","485.00","485.00","375.00","345.00","475.00","425.00","475.00","525.00","475.00","525.00","475.00"};
        int i, j,k;
        k=0;
        for (i = 0; i < sizeof(cat)/sizeof(cat[0]); i++){
            stringstream query;
            query << "INSERT INTO menu_category (category) VALUES (\"" << cat[i] << "\")";
            mysql_query(mysql, query.str().c_str());
            for (j = 0; j < catI[i]; j++){
                stringstream query;
                query << "INSERT INTO menu_items (name,price,description,itemImage,discount,category) VALUES (\""
                      << its[k+j] << "\"," << price[k+j] << ", \" \",\"\",0," << (i + 1) << ")";
                mysql_query(mysql, query.str().c_str());
            }
            k+=catI[i];
        }
        string cus[10] = {"Rushab","Abhijeet","Aatish","Yugesh","Arpan","Ishan","Abiral","Tom","Harry","Pawan"};
        string mi[10] = {"1,21,32","1,22,33","2,31,32","21,23,31","21,22,33","21,28,32","13,14,52","21,22,53","11,32,43","32,50,51"};
        string d[10] = {"3,1,4","2,1,3","5,2,2","6,5,3","6,1,2","2,9,5","7,2,1","2,5,3","1,1,2","5,2,2"};
        string da[10] = {"2020-08-12","2020-07-18","2020-07-19","2020-06-01","2020-02-15","2020-05-12","2020-01-22","2020-06-10","2020-05-24","2020-08-02"};
        
        for (i = 0; i < 10; i++){
            stringstream query;
            query << "INSERT INTO sales (customer, totalPrice, discount, serviceCharge, vat, oComplete, date, time, quantity, menuItems) VALUES (\"" << cus[i]<< "\",0,0,0,0,0, \"" <<da[i]<< "\" , CURRENT_TIME(),\""<< d[i] << "\",\"" << mi[i] <<"\");";
            mysql_query(mysql, query.str().c_str());
        }
            mysql_query(mysql, "INSERT INTO restaurant (name,contactNo,address,panNo,serviceCharge,vat) VALUES (\"KU NAN HOUSE\",\"016352365\",\"Dhulikhel\",\"XXXXXXXXX\",\"13\",\"13\");");

        
    }
    else{
        cout << "Not Connected";
    }
}