#include "models.h"

using namespace std;

// OperatorModel
OperatorModel::OperatorModel(int a_id, string a_username, string a_password, int a_restaurantID){
    id = a_id;
    username = a_username;
    password = a_password;
    restaurantID = a_restaurantID;
}

int OperatorModel::create(string a_data, string a_image)
{
    stringstream queryBuilder;
    queryBuilder << "INSERT INTO " << table << "(" << fields << ")  VALUES (" << parseString(a_data)
        << ",\""<< a_image <<"\");";
    cout<<queryBuilder.str();
    mysql_query(mysql, queryBuilder.str().c_str());
    return 1;
}

int OperatorModel::updateImage(string a_identifier, string a_attribute, string a_data, string a_image) { 
    stringstream queryBuilder;
    queryBuilder << "UPDATE " << table << " SET " << parseUpdateString(a_attribute, a_data) << ", profileImage = \"" << a_image << "\"" << " WHERE id= " << a_identifier << ";";
    mysql_query(mysql, queryBuilder.str().c_str());  
    return 1;
}

// Restaurant Model
RestaurantModel::RestaurantModel(int a_id, string a_Name, string a_Address, long long unsigned int a_contactNo){
    id = a_id;
    name = a_Name;
    address = a_Address;
    contactNo = a_contactNo;
}

// MenuCategoryModel
MenuCategoryModel::MenuCategoryModel(int a_id, string a_category){
    id = a_id;
    category = a_category;
}



/**
    * @brief Constructor to set the values of id, name, price, category and discount
    * 
    * @params: a_id (int) : ID of Menu Item,
    *          a_name (string) : Name of the Item,
    *          a_price (float) : Price of the Item ,
    *          a_category (string) : Category of the Item,
    *          a_discount (float) : Discount given on the Item
    * @returns: void
*/

MenuItemsModel::MenuItemsModel(int a_id, string a_name, float a_price, string a_category, float a_discount){
    id = a_id;
    name = a_name;
    price = a_price;
    category = a_category;
    discount = a_discount;
}



/**
    * @brief Function to create a new menu item
    * 
    * @params: a_data (string) : Comma separated values of name, price, category and discount
    *          a_description () : Description of the item,
    *          a_image (string) : Base64 encoded string of image
    * 
    * @returns: 1 if sucessfull, 0 if failed
*/

int MenuItemsModel::create(string a_data, string a_description, string a_image){
    stringstream queryBuilder;
    queryBuilder << "INSERT INTO " << table << " (name, price, category, discount, description, itemImage) VALUES (" << parseString(a_data) << ", \""<< a_description << "\",\"" << a_image <<"\");";
    mysql_query(mysql, queryBuilder.str().c_str());
    int lastid = mysql_insert_id(mysql);
    return lastid;
}



/**
    * @brief Function to update existing menu item except image
    * 
    * @params: a_identifier (string) : ID of the item to update
    *          a_attribute (string) : Attributes to update
    *          a_data (string) : Comma separated values of name, price, category and discount
    *          a_description () : Description of the item
    * @returns: 1 if sucessfull, 0 if failed
*/

int MenuItemsModel::update(string a_identifier, string a_attribute, string a_data, string a_description){
    stringstream queryBuilder;

    queryBuilder << "UPDATE " << table << " SET " << parseUpdateString(a_attribute, a_data) << ", description=\"" << a_description << "\"" << " WHERE id= " << a_identifier << ";";

    mysql_query(mysql, queryBuilder.str().c_str());

    return 1;
}



/**
    * @brief Function to update existing menu item when new image is uploaded
    * 
    * @params: a_identifier (string) : ID of the item to update
    *          a_attribute (string) : Attributes to update
    *          a_data (string) : Comma separated values of name, price, category and discount
    *          a_description (string) : Description of the item,
    *          a_image (string) : Base64 encoded string of image
    * @returns: 1 if sucessfull, 0 if failed
*/

int MenuItemsModel::update(string a_identifier, string a_attribute, string a_data, string a_description, string a_image){
    stringstream queryBuilder;
    queryBuilder << "UPDATE " << table << " SET " << parseUpdateString(a_attribute, a_data) << ", description=\"" << a_description << "\", itemImage=\"" << a_image << "\"" << " WHERE id= " << a_identifier << ";";
    mysql_query(mysql, queryBuilder.str().c_str());
    return 1;
}



/**
    * @brief Function to get details of menu items from the database
    * 
    * @params: m_items (string) : Comma separated IDs of menu items
    * @returns: Details of all m_items in two dimensional vector of strings
*/

vector<vector<string>> MenuItemsModel::getItemDetails(string m_items){
    vector<string> m_id = csvToArray(m_items);
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;
    queryBuilder << "SELECT *" << " FROM " << table << " WHERE";
    for (unsigned int i=1;i<m_id.size();i++){
        queryBuilder << " id = " << m_id[i];
        if(i != m_id.size()-1){
            queryBuilder << " OR";
        }
    }
    mysql_query(mysql, queryBuilder.str().c_str());
    res = mysql_store_result(mysql);
    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;

    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))){
        for (int j = 0; j < num_fields; j++){
            objArray[i][j] = row[j];
        }
        i++;
    }
    return objArray;
}
string MenuItemsModel::getItemDetailsJSON(string m_items){
    string jsonData;
    vector<vector<string>> objArray = getItemDetails(m_items);
    if(objArray.size()!=0){
        jsonData = JsonBuilder(csvToArray(fields), objArray);
    }else{
        jsonData = "{}";
    }
    return jsonData;
}

// SalesModel
SalesModel::SalesModel(int a_id, string a_menuItems, float a_totalPrice, bool a_oComplete, string a_dateTime){
    id = a_id;
    totalPrice = a_totalPrice;
    oComplete = a_oComplete;
    menuItems = a_menuItems;
    dateTime = a_dateTime;
}



/**
    * @brief: Function that retrieves sales from the database
    *         if a_where data = 0 retrieves orders that have yet to be completed/billed
    *         if a_where_data = 1 retrieves orders that have been compelted/billed
    * 
    * @params: a_where_data (0 or 1)
    * @returns: Required sales as JSON String
*/

string SalesModel::retrieveOrders(string a_where_data)
{
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;
    queryBuilder << "SELECT *  FROM " << table << " WHERE oComplete= " << a_where_data;

    mysql_query(mysql, queryBuilder.str().c_str());

    res = mysql_store_result(mysql);

    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;
    if(num_records == 0){
        return "{}";
    }
    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))){
        for (int j = 0; j < num_fields; j++){
            objArray[i][j] = row[j];
        }
        i++;
    }
    string jsonData;
    jsonData = JsonBuilder(csvToArray(fields), objArray);
    return jsonData;
}



/**
    * @brief: Removes a specific MenuItem from the Item list of a particular order
    * 
    * @params: a_identifier (id for the required sales model), 
    *          a_menu_items (csv of item ids in the list of orders in the sale), 
    *          string(id for the item that is to be deleted from the list)
    * @returns: 1 if task is completed, 0 if not completed
*/

int SalesModel::removeItem(string a_identifier, string a_menu_items, string a_delete_item)
{
    string strBuilder;
    string rightToken;
    int pos;
    bool flag;
    flag = true;
    if(a_menu_items.find(',')==string::npos){
        strBuilder = " ";
    }
    for (;;){
        a_menu_items = lstrip(a_menu_items);
        pos = a_menu_items.find(',');
        rightToken = a_menu_items.substr(0, pos);
        a_menu_items = a_menu_items.substr(pos + 1, a_menu_items.length() - pos - 1);
        rightToken = rstrip(rightToken);        
        if(rightToken != a_delete_item){
            strBuilder += rightToken + ",";
        }
        if (flag == false){
            break;
        }
        if (a_menu_items.find(',') == string::npos){
            flag = false;
        }
    }

    return updateSaleItems(a_identifier, strBuilder.substr(0, strBuilder.length() - 1));
}



/**
    * @brief: Overloaded create function from Base Model to allow adding csv data for menuItems and quantities
    *         menuItem field stores csv of the ids for the items in the orderlist
    *         quantity stores the csv of the quantity for each orderlist items respectively
    * 
    * @params: a_data(a string all the data excluding menuItems and quantity), 
    *          a_csv (a string of data consisting values for menuItems and quantity)
    * @returns: 1 if task is completed, 0 if not completed
*/

int SalesModel::create(string a_data, string a_csv){
    stringstream queryBuilder;
    queryBuilder << "INSERT INTO " << table << "(" << fields << ") VALUES (" << parseString(a_data) << ", CURRENT_DATE(), CURRENT_TIME()" << ","<< a_csv
                 << ");";

    mysql_query(mysql, queryBuilder.str().c_str());

    int lastid = mysql_insert_id(mysql);
    return lastid;
}



/**
    * @brief: Function to update the menuItem csv for the required order
    * 
    * @params: a_id (id for the selected order), a_data (new csv for the menuItem)
    * @returns: 1 if task is completed, 0 if not completed
*/

int SalesModel::updateSaleItems(string a_id, string a_data){
    stringstream queryBuilder;
    queryBuilder << "UPDATE " << table << " SET menuItems = \"" << a_data << "\" WHERE id= " << a_id;
    mysql_query(mysql, queryBuilder.str().c_str());
    return 1;
}



/**
    * @brief: Function to return the dates for the first ever completed order and the latest completed order
    * 
    * @params: null
    * @returns: 1 if task is completed, 0 if not completed
*/

string SalesModel::getSaleDateBounds(){
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;
    queryBuilder << "(SELECT date FROM sales WHERE oComplete= 1 ORDER BY date LIMIT 1) UNION ALL (SELECT date FROM sales WHERE oComplete= 1  ORDER BY date DESC LIMIT 1)";

    mysql_query(mysql, queryBuilder.str().c_str());

    res = mysql_store_result(mysql);
    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;
    if(num_records == 0){
        return "{}";
    }
    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))){
        for (int j = 0; j < num_fields; j++){
            objArray[i][j] = row[j];
        }
        i++;
    }
    string jsonData;
    vector<string> f(1);
    f[0] = "date";
    jsonData = JsonBuilder(f, objArray);
    return jsonData;
}



/**
    * @brief: Function to return the list of sales within a required date
    * 
    * @params: a_start_date (start date), a_end_date (end date)
    * @returns: required list of sales as a JSON String
*/

string SalesModel::retrieveOrderByDate(string a_start_date, string a_end_date)
{
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;
    queryBuilder << "SELECT * FROM sales WHERE oComplete = 1 AND date >= \""<< a_start_date << "\" AND date<=\"" << a_end_date << "\"";

    mysql_query(mysql, queryBuilder.str().c_str());

    res = mysql_store_result(mysql);

    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;
    if(num_records == 0){
        return "{}";
    }
    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))){
        for (int j = 0; j < num_fields; j++){
            objArray[i][j] = row[j];
        }
        i++;
    }
    string jsonData;
    jsonData = JsonBuilder(csvToArray(fields), objArray);
    return jsonData;
}



/**
    * @brief: Function to return the amount of sales that have been either completed or not completed
    *         if a_flag = 0 retrieves for not completed
    *         if a_flag = 1 retrieves for completed
    * 
    * @params: a_flag (0 or 1)
    * @returns: required count of sales as a JSON String
*/

string SalesModel::getOrderCount(string a_flag)
{
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;
    queryBuilder << "SELECT COUNT(id) AS count FROM sales WHERE oComplete = \"" << a_flag << "\"";

    mysql_query(mysql, queryBuilder.str().c_str());

    res = mysql_store_result(mysql);

    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;
    if(num_records == 0){
        return "{}";
    }
    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))){
        for (int j = 0; j < num_fields; j++){
            objArray[i][j] = row[j];
        }
        i++;
    }
    string jsonData;
    vector<string> f(1);
    f[0] = "count";
    jsonData = JsonBuilder(f, objArray);
    return jsonData;
}



/**
    * @brief: Function to get required stats (total, best) for orders within a required date
    *         best (best selling item within the date)
    *         total (total amount of revenue within the date)
    * 
    * @params: a_start_date (start date), a_end_date (end date)
    * @returns: required stats as a JSON String
*/

string SalesModel::getStatsByDate(string a_start, string a_end){
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;
    queryBuilder << "SELECT totalPrice, menuItems FROM sales WHERE oComplete = 1 AND date >= \""<< a_start << "\" AND date<=\"" << a_end << "\"";

    mysql_query(mysql, queryBuilder.str().c_str());

    res = mysql_store_result(mysql);

    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;
    if(num_records == 0){
        return "{}";
    }
    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))){
        for (int j = 0; j < num_fields; j++){
            objArray[i][j] = row[j];
        }
        i++;
    }

    float total=0;
    for(int i=0;i<num_records;i++){
        total += stof(objArray[i][0]);
    }

    string item;
    stringstream mItemStream;
    vector<string> tempStream;
    vector<string> itemList;
    for(int i = 0;i<num_records;i++){
        mItemStream << objArray[i][1];
        tempStream = splitToArray(mItemStream);
        itemList.insert(end(itemList), begin(tempStream), end(tempStream));
        mItemStream.clear();
    }
    int max_count = 0;
    int best = 0;
    for (unsigned int i=0;i<itemList.size();i++){
        int count=1;
        for (unsigned int j=i+1;j<itemList.size();j++){
            if (itemList[i]==itemList[j]){
                count++;
            }
        }
        if (count>max_count){
            best = stoi(itemList[i]);
            max_count = count;
        }
    }

    stringstream jsonData;
    jsonData << "[{\"total\":\"" << total << "\",\"best\":\"" << best << "\"}]";
    return jsonData.str();
}



/**
    * @brief: Function to retrieve various details about an order for bill printing purposes 
    *         i.e (total, discount, vat, service, gtotal, panNo)
    * 
    * @params: a_id (id for the selected sales order)
    * @returns: required data as a JSON String
*/

string SalesModel::getBillDetails(string a_id){
    vector<vector<string>> menuItem;
    vector<vector<string>> sale;
    vector<vector<string>> restaurantDet;
    vector<string> quantityList;
    stringstream temp;
    RestaurantModel obj;
    restaurantDet = obj.retrieve("panNo,serviceCharge,vat","id","1");
    sale = retrieve("quantity,menuItems","id",a_id);
    MenuItemsModel obj1;
    menuItem = obj1.getItemDetails(sale[0][1]);
    temp << sale[0][0];
    quantityList = splitToArray(temp);
    float total=0;
    float tempT = 0;
    float discount = 0;
    float service = 0;
    float vat = 0;
    float gtotal = 0;
    for(unsigned int i = 0;i<menuItem.size();i++){
        tempT = stof(menuItem[i][2]) * stof(quantityList[i]);
        total += tempT;
        discount += tempT * (float)(stof(menuItem[i][5])/100);
    }
    service = total*(float)(stof(restaurantDet[0][1])/100);
    vat = total*(float)(stof(restaurantDet[0][2])/100);
    gtotal = total-discount+service+vat;
    stringstream jsondata;
    jsondata << "[{\"total\":\""<< total <<"\",\"discount\":\"" << discount << "\",\"service\":\"" << service << "\", \"vat\":\"" << vat << "\",\"gtotal\":\"" << gtotal << "\",\"panNo\":\"" << restaurantDet[0][0] <<"\"}]";
    return jsondata.str();
}



/**
    * @brief: Function to retrieve the number of items in an orderlist for a sale
    * 
    * @params: a_id (id for the selected sales order)
    * @returns: number of items in a orderlist
*/

int SalesModel::getItemCount(string a_id){
    stringstream selectedSales;
    selectedSales << retrieve("menuItems","id",a_id)[0][0];
    vector<string> tempArray = splitToArray(selectedSales);
    return tempArray.size();
}

//Bill Tempalte Model
