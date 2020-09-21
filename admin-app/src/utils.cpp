#include "utils.h"

using namespace std;



/**
    * @brief Function to decode Base64 string
    * 
    * @params: null
    * @returns: Decoded char buffer
*/

unsigned char* Base64::decode()
{
    int paddding_size = 0;
    paddding_size += (base64_string[base64_string.length()-1]=='=')?1:0;
    paddding_size += (base64_string[base64_string.length()-2]=='=')?1:0;
    buffer_size = base64_string.length()* 3/4 - paddding_size;
    buffer = new unsigned char[buffer_size];
    for(int i = 0; i < base64_string.length(); i+=4)
    {
        int b_index = i*3/4;
        unsigned char b64_vals[4];
        unsigned char bytes[3];

        b64_vals[0] = b64(base64_string[i]);
        b64_vals[1] = b64(base64_string[i+1]);
        b64_vals[2] = b64(base64_string[i+2]);
        b64_vals[3] = b64(base64_string[i+3]);

        buffer[b_index] = (b64_vals[0]<<0x2)^(b64_vals[1]>>0x4);
        buffer[b_index+1] = ((b64_vals[1]&0xF)<<0x4)^(b64_vals[2]>>0x2);
        buffer[b_index+2] = ((b64_vals[2]&0x3)<<0x6)^b64_vals[3];
    }
    return buffer;
}



/**
    * @brief Function to decode Base64 string and write to a binary file
    * 
    * @params: filename (string): Name of output file
    * @returns: null
*/

void Base64::decode(string filename)
{
    ofstream output;
    output.open(filename, ios::out | ios::binary);
    decode();
    output.write((char *)buffer,buffer_size);
    output.close();
}



/**
    * @brief: Function to encode binary file or text to Base64
    * @params: null
    * @returns: Base64 Encoded String
*/

string Base64::encode()
{
    if(input_mode==Base64::FileMode)
    {
        ifstream file;
        file.open(source_filename,ios::in | ios::binary);
        file.seekg(0,ios::end);
        buffer_size = file.tellg();
        file.seekg(0,ios::beg);

        buffer = new unsigned char[buffer_size];
        file.read((char *)buffer, buffer_size);
        file.close();
    }

    else if(input_mode==Base64::TextMode)
    {
        buffer_size = source_string.length();
        buffer = new unsigned char[buffer_size];
        buffer = (unsigned char *)source_string.c_str();
    }

    int padding_length = buffer_size % 3;

    for(int i = 0; i < buffer_size; i+=3)
    {
        unsigned char separatedBits[4];

        separatedBits[0] = buffer[i+0] >>0x2;
        separatedBits[1] = ((buffer[i+0] & 0x3)<<0x4)^(buffer[i+1] >> 0x4);
        separatedBits[2] = ((buffer[i+1] & 0xF)<<0x2)^(buffer[i+2] >> 0x6);
        separatedBits[3] = (buffer[i+2] & 0x3F);

        char character;
        for(int j = 0; j <= 3; j++)
        {
            if(separatedBits[j] <= 0x19)
            {
                character = 'A' + separatedBits[j];
            }
            else if(separatedBits[j] >= 0x1A && separatedBits[j] <= 0x33)
            {
                character = 'a' + separatedBits[j] - 0x1A;
            }
            else if(separatedBits[j] >= 0x34 && separatedBits[j] <= 0x3D)
            {
                character = '0' + separatedBits[j] - 0x34;
            }
            else if(separatedBits[j] == 0x3E)
            {
                character = '+';
            }
            else if(separatedBits[j] == 0x3F)
            {
                character = '/';
            }
            base64_string += character;
        }

    }
    if(padding_length==1){
        base64_string = base64_string.substr(0,base64_string.length()-2) + "==";
    }
    else if(padding_length==2){
        base64_string = base64_string.substr(0,base64_string.length()-1) + "=";
    }
    return base64_string;
}

// ____________________ Utility Functions ________________________



/**
    * @brief: Function to strip the blank spaces or newline characters located 
    *          at the LEFT of the given input
    * 
    * @params: a_input (input string that needs stripping)
    * @returns: d_input (left-stripped string)
*/

string lstrip(string a_input){
    string d_input = a_input;
    while (d_input.front() == ' ' || d_input.front() == '\n'){
        d_input.erase(0, 1);
    }
    return d_input;
}



/**
    * @brief: Function to strip the blank spaces or newline characters located 
    *          at the RIGHT of the given input 
    * 
    * @params: a_input (input string that needs stripping)
    * @returns: d_input (right-stripped string)
*/

string rstrip(string a_input){
    string d_input = a_input;
    while (d_input.back() == ' ' || d_input.front() == '\n'){
        d_input.pop_back();
    }
    return d_input;
}



/**
    * @brief: Function to:
    *          parse the given comma seperated values, 
    *          find each individual values, 
    *          strip these values off of balnk and newline character
    *          rejoin the stripped values using comma.
    *          
    *          Called to:
    *          remove inconsistencies in the values at data base.
    *          (inconsistencies includes blank spaces and newline characters present in the left 
    *          and right of a value)
    * 
    * @params: a_input (variable that stores the non-formatted values in csv form, i.e csv)
    * @returns: formatted string with comma seperated value which are stripped both left and right 
    *           inorder to remove any unwanted blank or newline characters
*/

string parseString(string a_input){
    string strBuilder;
    string rightToken;
    int pos;
    bool flag;
    flag = true;
    if(a_input.find(',')==string::npos){
        strBuilder += "\"" + a_input + "\"";
        return strBuilder;
    }
    for (;;){
        a_input = lstrip(a_input);
        pos = a_input.find(',');
        rightToken = a_input.substr(0, pos);
        a_input = a_input.substr(pos + 1, a_input.length() - pos - 1);
        rightToken = rstrip(rightToken);
        strBuilder += "\"" + rightToken + "\",";
        if (flag == false){
            break;
        }
        if (a_input.find(',') == string::npos){
            flag = false;
        }
    }
    return (strBuilder.substr(0, strBuilder.length() - 1));
}




/**
    * @brief: Function to:
    *          parse the given comma seperated values, 
    *          find each individual values, 
    *          strip these values off of blank and newline character,
    *          rejoin the stripped values as required by the UPDATE SQL QUERY in UPDATE method
    * 
    *          Called to:
    *          format the input values for UPDATE query specifically,
    *          remove inconsistencies in the values at data base.(inconsistencies includes 
    *          blank spaces and newline characters present in the left and right of a value)
    * 
    * @params: a_input (variable that stores the non-formatted values in csv form)
    * @returns: formatted string which matches the UPDATE query requirement
*/

string parseUpdateString(string a_attribute, string a_input){
    string strBuilder;
    string rightInputToken, rightAttrToken;
    int attrPos, inputPos;
    bool flag;
    flag = true;
    a_input = lstrip(a_input);
    a_input = rstrip(a_input);
    if(a_input.find(',')==string::npos){
        strBuilder += a_attribute + "= \"" + a_input + "\"";
        return strBuilder;
    }
    for (;;){
        a_attribute = lstrip(a_attribute);
        a_input = lstrip(a_input);

        attrPos = a_attribute.find(',');
        inputPos = a_input.find(',');

        rightAttrToken = a_attribute.substr(0, attrPos);
        rightInputToken = a_input.substr(0, inputPos);

        a_attribute = a_attribute.substr(attrPos + 1, a_attribute.length() - attrPos - 1);
        a_input = a_input.substr(inputPos + 1, a_input.length() - inputPos - 1);

        rightAttrToken = rstrip(rightAttrToken);
        rightInputToken = rstrip(rightInputToken);
        strBuilder += rightAttrToken + "= \"" + rightInputToken + "\",";
        if (flag == false){
            break;
        }
        if (a_input.find(',') == string::npos){
            flag = false;
        }
    }
    return (strBuilder.substr(0, strBuilder.length() - 1));
}



/**
    * @brief: Function to find the id (Primary Key) in the database that 
    *         matches the defined criteria -> (Table Name, Column Name and Value)

    * @params: a_table (Table Name to be looked in the Database), a_attribute 
    *          (Column Name to be looked in the Table), a_data (Value to look for in the Column)
    * @returns: Empty String or Primary Key (Primary Key if the query successfully executes 
    *           and retrieves the id from database, and Empty String if not)
*/

string pkFinder(string a_table, string a_attribute, string a_data){
    MYSQL* mysql;
    MYSQL_RES* res;
    MYSQL_ROW row;
    mysql = mysql_init(0);
    mysql = mysql_real_connect(mysql, SERVER, UNAME, PWORD, DBNAME, PORT, NULL, 0);
    stringstream queryBuilder;
    queryBuilder << "SELECT id FROM " << a_table << " WHERE " << a_attribute << " = \"" << a_data
                 << "\"";
    mysql_query(mysql, queryBuilder.str().c_str());
    res = mysql_store_result(mysql);
    row = mysql_fetch_row(res);
    mysql_close(mysql);
    return row[0];
}



/**
    * @brief : Function to split the individual values of given CSV input into different elements of an array
    * 
    * @params: a_csv (variable that has values in comma seperated format)
    * @returns: retArray (array that contains the individual comma seperated values of 
    *            a_csv in different element)
*/

vector<string> csvToArray(string a_csv){
    vector<string> retArray(1);
    string strBuilder;
    string rightToken;
    int vecSize, pos;
    bool flag;
    flag = true;
    retArray[0] = "id";
    retArray.resize(2);
    vecSize = 2;
    if(a_csv.find(',')==string::npos){
        retArray[vecSize-1] = a_csv;
        return retArray;
    }
    for (;;){
        a_csv = lstrip(a_csv);
        pos = a_csv.find(',');
        rightToken = a_csv.substr(0, pos);
        a_csv = a_csv.substr(pos + 1, a_csv.length() - pos - 1);
        retArray[vecSize - 1] = rightToken;
        retArray.resize(vecSize + 1);
        vecSize++;
        if (flag == false){
            break;
        }
        if (a_csv.find(',') == string::npos){
            flag = false;
        }
    }
    retArray.resize(retArray.size() - 1);
    return retArray;
}



/**
    * @brief : Function to build a JSON Data format from the given key-value pairs 
    * 
    * @params: a_key (array that stores all the keys of key-value pair), 
    *          a_value (array that stores all the values of key-value pair)
    * @returns : jBuilder (String that contains the built JSON Data Format
    *            from each corresponding key-value pairs)
*/

string JsonBuilder(vector<string> a_key, vector<vector<string> > a_value){
    stringstream jBuilder;
    jBuilder << "[";
    for (unsigned int j = 0; j < a_value.size(); j++){
        jBuilder << "{ ";
        for (unsigned int i = 0; i < a_key.size(); i++){
            jBuilder << "\"" << a_key[i] << "\" : \"" << a_value[j][i] << "\"";

            if (i == a_key.size() - 1){
                break;
            }
            jBuilder << ",";
        }
        jBuilder << " }";
        if (j == a_value.size() - 1){
            break;
        }
        jBuilder << ",";
    }
    jBuilder << "]";
    return jBuilder.str();
}



/**
    * @brief: Function to check for any encountered mysqlErrors that are encountered
    * 
    * @params: mysql (mysql object)
    * @returns: 1 if no erros are found, 0 if errors are found
*/

int mysqlErrorCheck(MYSQL* mysql){
    if (strcmp(mysql_error(mysql),"")){
        return 1;
    }else{
        return 0;
    }
}



/**
    * @brief: Function to split a stringstream csv into a vector<string> array
    * 
    * @params: stringstream (string containing csv)
    * @returns: csv split into an vector<string> array
*/

vector<string> splitToArray(stringstream& a_input){
    string item;
    vector<string> itemList;
    while(getline(a_input, item, ',')){
        itemList.push_back(item);
    }
    return itemList;
}



/**
    * @brief: Function to pass exported Bill to the printer queue
    * 
    * @params: filename (path for the required file)
    * @returns: void
*/

void printBill(string filename)
{
    stringstream command;
    stringstream filestring;
    filestring << QDir::homePath().toStdString() << "\\Documents\\ExportedBill\\" << filename;
    command << "powershell -command \"start-process -filepath '" << filestring.str() << "' -verb print\"";
    system(command.str().c_str());
}
