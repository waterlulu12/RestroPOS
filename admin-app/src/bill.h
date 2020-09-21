#ifndef BILL_H
#define BILL_H

#include <iostream>
#include <vector>
#include <fstream>
#include "utils.h"
#include "models.h"
#include <QDir>

using namespace std;


class Bill
{
    private:
        ifstream temp;
        int length;
        int finder(char* &buffer, int bufferSize, string find)
        {
            for(int i = 0; i < bufferSize; i++)
            {
                if(find.at(0) == buffer[i])
                {
                    for(unsigned int j = 1; j < find.length(); j++)
                    {
                        if(find.at(j)!=buffer[i+j])
                        {
                            break;
                        }
                        else
                        {
                            if(j == find.length()-1)
                            {
                                return i;
                            }                 
                        }
                    }
                }
            }
            return -1;
        }

        void replacer(char* &buffer, int bufferSize, string find, string replaceString){
            int offset = finder(buffer, bufferSize, find);
            if(offset == -1)
            {
                cout << "Couldn't find: " << find << endl;
            }
            unsigned int length = find.size();

            if(replaceString.size() < find.size())
            {
                for(unsigned int y = 0; y < replaceString.size() - find.size(); y++)
                {
                    replaceString += " ";
                }
            }

            if(replaceString.size() > find.size())
            {
                replaceString = replaceString.substr(0,find.size()-3);
                replaceString += "..";
            }

            for(unsigned int i =0; i < length; i++)
            {
                buffer[offset+i] &= 0x0;
                if(i < replaceString.length())
                {
                    buffer[offset+i] = replaceString.at(i);
                }        
            }
        }
    
    public:
        Bill(string id){
            SalesModel salesRetriever;
            RestaurantModel restaurantRetriever;
            string billData;
            BillTemplateModel billTemp;
            int max_size;
            int itemCount = salesRetriever.getItemCount(id);
            if(itemCount <= 15){
                billData = billTemp.retrieve("bill","id","1")[0][0];
                max_size = 15;
            }else if(itemCount > 15 && itemCount <=30){
                billData = billTemp.retrieve("bill","id","2")[0][0];
                max_size = 30;
            }else if(itemCount > 30 && itemCount <=60){
                billData = billTemp.retrieve("bill","id","3")[0][0];
                max_size = 60;
            }else{
                max_size = 0;
            }
            Base64 obj(billData,Base64::DecodeMode);

            char* buffer = (char*) obj.decode();
            length = obj.buffer_size;

            vector<string> retrievedSalesVector = salesRetriever.retrieve("*", "id", id)[0];
            vector<string> retrievedRestaurantVector = restaurantRetriever.retrieve("*", "id", "1")[0];

            replacer(buffer, length,"$(#CUSTOMER_NAME#)",retrievedSalesVector[1]);
            replacer(buffer, length, "$(#ORDER_TOKEN#)","OT10" + retrievedSalesVector[0]);
            replacer(buffer, length, "$(#BILL_DATE#)",retrievedSalesVector[7]);
            replacer(buffer, length, "$(#TIME_OF_BILLING#)",retrievedSalesVector[8]);
            replacer(buffer, length, "$(#RESTAURANT_NAME#)", retrievedRestaurantVector[1]);
            replacer(buffer, length, "$(#RESTAURANT_ADDRESS#)", retrievedRestaurantVector[3]);
            replacer(buffer, length, "$(#CONTACT#)", retrievedRestaurantVector[2]);
            replacer(buffer, length, "$(#PAN_NUMBER#)", retrievedRestaurantVector[4]);

            MenuItemsModel menuRetriever;
            vector<vector<string>> items = menuRetriever.getItemDetails(retrievedSalesVector[10]);

            vector<string> quantityVector = csvToArray(retrievedSalesVector[9]);

            int subTotal = 0;

            for(unsigned int i = 0; i < items.size(); i++){
                
                string replaceStrings[4];
                stringstream snTempBuilder;
                snTempBuilder << ((i+1<10) ? "$(#ID_0" : "$(#ID_") << i+1 << "#)";
                replaceStrings[0] = snTempBuilder.str();
                replacer(buffer,length,replaceStrings[0],to_string(i+1));

                stringstream itemTempBuilder;
                itemTempBuilder << ((i+1<10) ? "$(#NAME_OF_ITEM_INDEX_0" : "$(#NAME_OF_ITEM_INDEX_") << i+1 << "#)";
                replaceStrings[1] = itemTempBuilder.str();
                replacer(buffer,length,replaceStrings[1],items[i][1]);

                stringstream quantityTempBuilder;
                quantityTempBuilder << ((i+1<10) ? "$(#QUANTITY_0" : "$(#QUANTITY_") << i+1 << "#)";
                string quantityTemp = quantityTempBuilder.str();
                int quantityTempi = stoi(quantityVector[i+1]);
                replacer(buffer,length,quantityTemp,quantityVector[i+1]);

                stringstream priceTempBuilder;
                priceTempBuilder << ((i+1<10) ? "$(#PRICE_0" : "$(#PRICE_") << i+1 << "#)";
                replaceStrings[2] = priceTempBuilder.str();
                int priceTempi = stoi(items[i][2]);
                replacer(buffer,length,replaceStrings[2],"Rs. " + items[i][2]);

                stringstream totalTempBuilder;
                totalTempBuilder << ((i+1<10) ? "$(#TOTAL_0" : "$(#TOTAL_") << i+1 << "#)";
                replaceStrings[3] = totalTempBuilder.str();
                replacer(buffer,length,replaceStrings[3],"Rs. " + to_string(quantityTempi*priceTempi));
                subTotal += quantityTempi*priceTempi;
            }

            replacer(buffer,length,"$(#SUB_TOTAL#)","Rs. " + to_string(subTotal));
            replacer(buffer,length,"$(#TOTAL_VAT#)","Rs. " + retrievedSalesVector[5]);
            replacer(buffer,length,"$(#TOTAL_TAX#)","Rs. " + retrievedSalesVector[4]);
            replacer(buffer,length,"$(#DISCOUNT#)","Rs. " + retrievedSalesVector[3]);
            replacer(buffer,length,"$(#GRAND_TOTAL#)","Rs. " + retrievedSalesVector[2]);

            for(unsigned int f = 0; f < (max_size-items.size()); f++){
                int i = items.size()+f;
                string replaceStrings[4];
                stringstream snTempBuilder;
                snTempBuilder << ((i+1<10) ? "$(#ID_0" : "$(#ID_") << i+1 << "#)";
                replaceStrings[0] = snTempBuilder.str();
                replacer(buffer,length,replaceStrings[0],"");

                stringstream itemTempBuilder;
                itemTempBuilder << ((i+1<10) ? "$(#NAME_OF_ITEM_INDEX_0" : "$(#NAME_OF_ITEM_INDEX_") << i+1 << "#)";
                replaceStrings[1] = itemTempBuilder.str();
                replacer(buffer,length,replaceStrings[1],"");

                stringstream quantityTempBuilder;
                quantityTempBuilder << ((i+1<10) ? "$(#QUANTITY_0" : "$(#QUANTITY_") << i+1 << "#)";
                string quantityTemp = quantityTempBuilder.str();
                replacer(buffer,length,quantityTemp,"");

                stringstream priceTempBuilder;
                priceTempBuilder << ((i+1<10) ? "$(#PRICE_0" : "$(#PRICE_") << i+1 << "#)";
                replaceStrings[2] = priceTempBuilder.str();
                replacer(buffer,length,replaceStrings[2],"");

                stringstream totalTempBuilder;
                totalTempBuilder << ((i+1<10) ? "$(#TOTAL_0" : "$(#TOTAL_") << i+1 << "#)";
                replaceStrings[3] = totalTempBuilder.str();
                replacer(buffer,length,replaceStrings[3],"");
            }
            stringstream filename;
            filename << QDir::homePath().toStdString() << "\\Documents\\ExportedBill\\" <<  "OT10" << retrievedSalesVector[0] << "_" << retrievedSalesVector[1] << ".xls";
            ofstream outfile (filename.str(),std::ofstream::binary);
            outfile.write(buffer,length);
            outfile.close();
        }

};

#endif
