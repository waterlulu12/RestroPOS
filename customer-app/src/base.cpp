#include "base.h"



/**
    * @brief:   Method modeled to be the constructor of the base class
    *           Initializes the values of fields and table to the the fieldname and
    *           tablename of the inherited classes that call this function
    *
    * @params:  a_table (string)  : name of the table of the inherited class
    *           a_fields(string)  : csv containing fields of the table of inherited class
    * @returns: 1
*/

int BaseModel::init(string a_fields, string a_table) {
    fields = a_fields;
    table = a_table;
    mysql = mysql_init(0);
    mysql = mysql_real_connect(mysql, SERVER, UNAME, PWORD, DBNAME, PORT, NULL, 0);
    return 1;
}



/**
    * @brief :  Creates a SQL query to add a new record to the database table
    *           "table" and "fields" are the class attribute
    *           a_data has the values to be inserted into the table
    *
    * @params:  a_data(string) : csv of values to be added to the MYSQL table
    * @returns: 1 if completed else 0
*/

int BaseModel::create(string a_data) {
    stringstream queryBuilder;
    queryBuilder << "INSERT INTO " << table << "(" << fields << ") VALUES (" << parseString(a_data)
        << ");";
    mysql_query(mysql, queryBuilder.str().c_str());
    return mysqlErrorCheck(mysql);
}



/**
    * @brief:   Creates a SQL query to update the existing records int the database
    *           "table" is the class attribute
    *
    * @params:  a_identifier(string) : id of the existing record in the database
    *           a_attribute (string) : csv of values to be replaced
    *           a_data      (string) : csv of replacing values
    * @returns: 1 if completed else 0
*/

int BaseModel::update(string a_identifier, string a_attribute, string a_data) { 
    stringstream queryBuilder;
    queryBuilder << "UPDATE " << table << " SET " << parseUpdateString(a_attribute, a_data)
        << " WHERE id= " << a_identifier << ";";
    mysql_query(mysql, queryBuilder.str().c_str());
    return mysqlErrorCheck(mysql);
}



/**
    * @brief:   Creates a SQL query to retrieve required data from the database
    *           "table" is the class attribute of the base class
    *
    * @params:  a_attribute(string) : Value to be retrueves
    * @returns: 2D vector string containing the values fetched from the database
*/

vector<vector<string>> BaseModel::retrieve(string a_attribute) {
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;
    queryBuilder << "SELECT " << a_attribute << " FROM " << table;

    mysql_query(mysql, queryBuilder.str().c_str());

    res = mysql_store_result(mysql);

    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;

    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))) {
        for (int j = 0; j < num_fields; j++) {
            objArray[i][j] = row[j];
        }
        i++;
    }
    return objArray;
}



/**
    * @brief:   Retrieves the data from the database in JSON format
    *           Calls retrieve() function to retrieve data
    *           Calls csvToArray() to convert the csv values into a array
    *           Calls JsonBuilder() to recieve the data in JSON format
    *
    * @params:  a_attribute (string) :   value to be retrieved
    * @returns: jsonData    (string) :   Returns data in JSON format
*/

string BaseModel::retrieveJSON(string a_attribute) {
    string jsonData;
    vector<vector<string>> objArray = retrieve(a_attribute);
    if (objArray.size() != 0) {
        jsonData = JsonBuilder(csvToArray(fields), objArray);
    }
    else {
        jsonData = "";
    }
    return jsonData;
}



/**
    * @brief :  Overloaded retrieve() function
    *           Creates a SQL query to retrieve required data from the database
    *           "table" is the class attribute of the base class
    *
    * @params:  a_attribute     (string) : value to be retrieved from the database
    *           a_where_column  (string) : column of the table of which the data is to be retrieved
    *           a_where_value   (string) : value filter
    * @returns: 2D vector string containing the values fetched from the database
*/

vector<vector<string>> BaseModel::retrieve(string a_attribute, string a_where_column, string a_where_value) {    
    MYSQL_RES* res;
    MYSQL_ROW row;
    stringstream queryBuilder;

    queryBuilder << "SELECT " << a_attribute << " FROM " << table << " WHERE " << a_where_column << " = \"" << a_where_value << "\"";

    mysql_query(mysql, queryBuilder.str().c_str());

    res = mysql_store_result(mysql);

    int num_fields = mysql_num_fields(res);
    int num_records = mysql_num_rows(res);
    int i = 0;
    vector<vector<string> > objArray(num_records, vector<string>(num_fields));

    while ((row = mysql_fetch_row(res))) {
        for (int j = 0; j < num_fields; j++) {
            objArray[i][j] = row[j];
        }
        i++;
    }
    return objArray;
}



 /**
    * @brief:   Overloaded retrieveJSON() function
    *           Calls retrieve() function to retrieve data
    *           Calls JsonBuilder() to recieve the data in JSON format
    *
    * @params:  a_attribute     (string) : Value to be retrieved from the database
    *           a_where_column  (string) : Column of the table of which the data is to be retrieved
    *           a_where_value   (string) : Value filter
    * @returns: jsonData        (string) : String in JSON format
*/

string BaseModel::retrieveJSON(string a_attribute, string a_where_column, string a_where_value) {
    string jsonData;
    vector<vector<string>> objArray = retrieve(a_attribute, a_where_column, a_where_value);
    if (objArray.size() != 0) {
        if (a_attribute == "*") {
            a_attribute = fields;
        }
        jsonData = JsonBuilder(csvToArray(a_attribute), objArray);
    }
    else {
        jsonData = "";
    }
    return jsonData;
}



/**
    * @brief:   Creates a SQL query to delete a record from the database table
    *           "table" is the class attribute of the base class
    *
    * @params:  a_identifier(string) : ID of the record to be removed
    * @returns: 1 if completed else 0
*/

int BaseModel::remove(string a_identifier) {

    

    stringstream queryBuilder;
    queryBuilder << "DELETE FROM " << table << " WHERE id= " << a_identifier << ";";
    mysql_query(mysql, queryBuilder.str().c_str());
    return mysqlErrorCheck(mysql);
}
