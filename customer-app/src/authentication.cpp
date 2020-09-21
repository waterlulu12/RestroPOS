#include "authentication.h"



/**
    * @brief: Function to check whether the passed username and password matches the record or not
    * 
    * @params: a_username(string): username passed by the user,
    *          a_password(string): password passed by the user
    * @returns: 0 if the passed username and password is not correct, 
    *           1 if the passed username and password is correct
*/

int Authentication::authenticate(string a_username, string a_password){
    MYSQL_RES* res;
    stringstream query;
    string hashedPassword = hashPassword(a_password);
    query << "SELECT * FROM operator WHERE username = \"" << a_username << "\" AND password = \"" << hashedPassword << "\"";
    try{
        mysql_query(mysql, query.str().c_str());
    }
    catch(...){
        error = 1;
    }
    res = mysql_store_result(mysql);
    int num_records = mysql_num_rows(res);

    if(num_records == 0){
        return 0;
    }else{
        return 1;
    }
}



/**
    * @brief: Function to check whether the passed password and comfirm-password matches or not
    * 
    * @params: a_password(string): password passed by user in password field,
    *          a_cPassword(string): password passed by user in comfirm-password field
    * @returns: 1 if password and confirm-password are same,
    *           0 if password and confirm-password are not same
*/

int Authentication::passwordMatch(string a_password, string a_cPassword){
    if(a_password == a_cPassword){
        return 1;
    }else{
        return 0;
    }
}



/**
    * @brief: Function to validate the password given by the user
    * 
    * @params: a_password(string): password passed by the user
    * @returns: 1 if the passed argument meets all of the conditions,
    *           0 if the conditions are not satisfied
*/

int Authentication::validatePassword(string a_password)
{
    // Min Size Validator
    int minSizeFlag = 0;
    if(a_password.size() >= MIN_PASSWORD_LENGTH){
        minSizeFlag = 1;
    }
    //Max Size Validator
    int maxSizeFlag = 0;
    if(a_password.size() <= MAX_PASSWORD_LENGTH){
        maxSizeFlag = 1;
    }
    //Contains Alphabet Validator
    int alphabetsFound=0;
    int alphabetsFoundFlag=0;
    for(unsigned int i = 0; i < a_password.size(); i++){
        char cur_char = a_password.at(i);
        if ((cur_char >= 65 && cur_char <= 90)||(cur_char >= 97 && cur_char <= 122))
        {
            alphabetsFound += 1;
        }
    }
    if(alphabetsFound >= MIN_ALPHABETS){
        alphabetsFoundFlag = 1;
    }
    //Contains Number Validator
    int numbersFound=0;
    int numbersFoundFlag=0;
    for(unsigned int i = 0; i < a_password.size(); i++){
        char cur_char = a_password.at(i);
        if (cur_char >= 48 && cur_char <= 57) {
            numbersFound += 1;
        }
    }
    if(numbersFound >= MIN_NUMS){
        numbersFoundFlag = 1;
    }
    //Contains Special Chars Validator
    int specialsFound=0;
    int specialsFoundFlag=0;
    for(unsigned int i = 0; i < a_password.size(); i++){
        char cur_char = a_password.at(i);
        if ((cur_char >= 33 && cur_char <= 47)||(cur_char >= 58 && cur_char <= 64))
        {
            specialsFound += 1;
        }
    }
    if(specialsFound >= MIN_SPECIALCHARS){
        specialsFoundFlag = 1;
    }
    if(minSizeFlag && maxSizeFlag && alphabetsFoundFlag && numbersFoundFlag && specialsFoundFlag){
        return 1;
    }
    else{
        return 0;
    }
}



/**
    * @brief: Function to check whether the passed username has required number of characters
    * 
    * @params: a_username(string): username passed by the user
    * @returns: 1 if the passed username has required number of characters,
    *           0 if the passed username has less than the required number of characters
*/

int Authentication::validateUsername(string a_username){
    if(a_username.size() >= 6){
        return 1;
    }else{
        return 0;
    }
}



/**
    * @brief: Function to hash the passed argument
    * 
    * @params: plainText(string): password passed by the user
    * @returns: Hashed value for the given argument
*/

string Authentication::hashPassword(string plainText)
{
    hash<string> hasher;
    stringstream modifier;
    modifier << hasher(plainText);
    return modifier.str();
}
