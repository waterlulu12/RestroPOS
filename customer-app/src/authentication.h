#ifndef AUTHENTICATION_H
#define AUTHENTICATION_H

#include <iostream>
#include <string>
#include <mysql/mysql.h>
#include "models.h"
#include "utils.h"
#include <sstream>
#include <unordered_map>

#define SERVER "127.0.0.1"
#define UNAME "root"
#define PWORD "password"
#define DBNAME "project"
#define PORT 3306

#define MIN_PASSWORD_LENGTH 8
#define MAX_PASSWORD_LENGTH 16
#define MIN_ALPHABETS 1
#define MIN_NUMS 1
#define MIN_SPECIALCHARS 1

using namespace std;



/** Authentication Class
    * 
    * @brief: A class that handles simple authentications to the database
    * 
*/

class Authentication{
    protected:
        MYSQL* mysql;
    public:
        int error;
        Authentication(){
            mysql = mysql_init(0);
            try{
                mysql = mysql_real_connect(mysql, SERVER, UNAME, PWORD, DBNAME, PORT, NULL, 0);
                if(!mysql){
                    throw 500; 
                }
            }
            catch(...){
                error = 1;
            }
        }
        int authenticate(string, string);
        int passwordMatch(string,string);
        string hashPassword(string);
        int validatePassword(string);
        int validateUsername(string);
        ~Authentication(){
            mysql_close(mysql);
        }
};

#endif
