#ifndef BASE_H
#define BASE_H

#include <iostream>
#include <mysql/mysql.h>
#include <sstream>
#include <string>
#include <vector>
#include "utils.h"

#define SERVER "127.0.0.1"
#define UNAME "root"
#define PWORD "password"
#define DBNAME "project"
#define PORT 3306

using namespace std;



/** BaseModel Class
    * 
    * @brief: A Parent class to all the models/database classes that contains the primary MySQL object 
    * for making database connections. Consists of fundamental functions such as create,update,remove
    * and retrieve that are used by all the models.
    * 
*/

class BaseModel{
private:
    string fields;
    string table;

protected:
    MYSQL* mysql;

public:
    int init(string, string);
    int create(string);
    int update(string, string, string);
    int remove(string);
    vector<vector<string>> retrieve(string = "*");
    string retrieveJSON(string = "*");
    vector<vector<string>> retrieve(string, string, string);
    string retrieveJSON(string, string, string);
    ~BaseModel(){
        mysql_close(mysql);
    }
};

#endif
