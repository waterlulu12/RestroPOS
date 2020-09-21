#ifndef MODELS_H
#define MODELS_H

#include <iostream>
#include <string>
#include <mysql/mysql.h>
#include "base.h"

using namespace std;



/** OperatorModel Class
    * 
    * @brief: A class that connects to the operator table in the MySQL database
    * 
*/

class OperatorModel : public BaseModel{
private:
    string fields = "username, password, restaurantID, admin, profileImage";
    string table = "operator";

public:
    int id, restaurantID;
    string username, password;
    OperatorModel(){
        init(fields, table);
    }
    OperatorModel(int, string, string, int);
    int create(string,string);
    int updateImage(string,string,string,string);
};



/** RestaurantModel Class
    * 
    * @brief: A class that connects to the restaurant table in the MySQL database
    * 
*/

class RestaurantModel : public BaseModel{
private:
    string fields = "name, contactNo, address, panNo, serviceCharge, vat";
    string table = "restaurant";

public:
    int id;
    long long unsigned int contactNo;
    string name, address;
    RestaurantModel(){
        init(fields, table);
    }
    RestaurantModel(int, string, string, long long unsigned int);
};



/** MenuCategory Class
    * 
    * @brief: A class that connects to the menu_category table in the MySQL database
    * 
*/

class MenuCategoryModel : public BaseModel{
private:
    string fields = "category";
    string table = "menu_category";

public:
    int id;
    string category;
    MenuCategoryModel(){
        init(fields, table);
    }
    MenuCategoryModel(int, string);
};



/** MenuItemsModel Class
    * 
    * @brief: A class that connects to the menu_items table in the MySQL database
    * 
*/

class MenuItemsModel : public BaseModel{
private:
    string fields = "name, price, description, category, discount, itemImage";
    string table = "menu_items";

public:
    int id;
    string name, category;
    float price, discount;
    MenuItemsModel(){
        init(fields, table);
    }
    MenuItemsModel(int, string, float, string, float);
    int create(string,string,string);
    int update(string,string,string,string);
    int update(string,string,string,string,string);
    vector<vector<string>> getItemDetails(string);
    string getItemDetailsJSON(string);
};



/** SalesModel Class
    * 
    * @brief: A class that connects to the sales table in the MySQL database
    * 
*/

class SalesModel : public BaseModel{
private:
    string fields = "customer, totalPrice, discount, serviceCharge, vat, oComplete, date, time, quantity, menuItems";
    string table = "sales";

public:
    int id;
    float totalPrice;
    bool oComplete;
    string menuItems, dateTime;
    SalesModel(){
        init(fields, table);
    }
    SalesModel(int, string, float, bool, string);
    string retrieveOrders(string);
    int removeItem(string,string,string);
    int create(string, string);
    int updateSaleItems(string,string);
    string getSaleDateBounds();
    string getStatsByDate(string,string);
    string retrieveOrderByDate(string,string);
    string getOrderCount(string);
    string getBillDetails(string);
    int getItemCount(string);
};



/** BillTemplateModel Class
    * 
    * @brief: A class that connects to the bill_template table in the MySQL database
    * 
*/

class BillTemplateModel : public BaseModel{
private:
    string fields = "bill";
    string table = "bill_template";

public:
    string name, address;
    BillTemplateModel(){
        init(fields, table);
    }
    BillTemplateModel(int, string, string, long long unsigned int);
};
#endif
