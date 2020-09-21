#include "serializer.h"

serializer::serializer(QObject *parent) : QObject(parent)
{

}

int serializer::createUser(QString a, QString b)
{
    OperatorModel obj1;
    obj1.create(a.toStdString(), b.toStdString());
    return 1;
}

int serializer::updateUser(QString a, QString b, QString c)
{
    OperatorModel obj1;
    obj1.update(a.toStdString(), b.toStdString(), c.toStdString());
    return 1;
}

int serializer::updateUser(QString a, QString b, QString c, QString d)
{
    OperatorModel obj1;
    Base64 obj(d.toStdString(),Base64::FileMode);
    obj1.updateImage(a.toStdString(), b.toStdString(), c.toStdString(), obj.encode());
    return 1;
}

QString serializer::getUser(QString a, QString b, QString c)
{
    OperatorModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON(a.toStdString(),b.toStdString(),c.toStdString()).c_str());
}

QString serializer::getCategory(){
    MenuCategoryModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON().c_str());
}

QString serializer::getCategory(QString a, QString b, QString c)
{
    MenuCategoryModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON(a.toStdString(), b.toStdString(), c.toStdString()).c_str());

}

QString serializer::getMenuItem(QString a, QString b, QString c)
{
    MenuItemsModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON(a.toStdString(), b.toStdString(), c.toStdString()).c_str());
}

QString serializer::getMenuItem()
{
    MenuItemsModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON().c_str());
}

int serializer::deleteItem(QString identifier)
{
    MenuItemsModel obj1;
    obj1.remove(identifier.toStdString());
    return 1;
}

int serializer::deleteCategory(QString identifier)
{
    MenuCategoryModel obj1;
    obj1.remove(identifier.toStdString());
    return 1;
}

int serializer::updateCategory(QString a, QString b, QString c)
{
    MenuCategoryModel obj1;
    obj1.update(a.toStdString(),b.toStdString(),c.toStdString());
    return 1;
}

int serializer::updateItem(QString a, QString b, QString c, QString d)
{
    MenuItemsModel obj1;
    obj1.update(a.toStdString(),b.toStdString(),c.toStdString(),d.toStdString());
    return 1;
}

int serializer::updateItem(QString a, QString b, QString c, QString d, QString e)
{
    MenuItemsModel obj1;
    Base64 obj(e.toStdString(),Base64::FileMode);
    obj1.update(a.toStdString(),b.toStdString(),c.toStdString(),d.toStdString(),obj.encode());
    return 1;
}

QString serializer::pkfind(QString a, QString b, QString c)
{
    return QString::fromUtf8(pkFinder(a.toStdString(),b.toStdString(),c.toStdString()).c_str());
}

int serializer::createMenuItem(QString a, QString b, QString c)
{
    MenuItemsModel obj1;
    string d;
    if(c.toStdString().compare("No Image Selected")==0){
        d = "";
    }else{
        Base64 obj(c.toStdString(),Base64::FileMode);
        d = obj.encode();
    }
    obj1.create(a.toStdString(),b.toStdString(),d);
    return 1;
}

int serializer::createCategory(QString a)
{
    MenuCategoryModel obj1;
    obj1.create(a.toStdString());
    return 1;
}

QString serializer::getSales(QString a)
{
    SalesModel obj1;
    return QString::fromUtf8(obj1.retrieveOrders(a.toStdString()).c_str());
}

QString serializer::getSalesBound()
{
    SalesModel obj1;
    return QString::fromUtf8(obj1.getSaleDateBounds().c_str());
}

QString serializer::getSalesByDate(QString a, QString b)
{
    SalesModel obj1;
    return QString::fromUtf8(obj1.retrieveOrderByDate(a.toStdString(),b.toStdString()).c_str());
}

QString serializer::getIDetails(QString a)
{
    MenuItemsModel obj1;
    return QString::fromUtf8(obj1.getItemDetailsJSON(a.toStdString()).c_str());
}

int serializer::submitBillButton(QString a, QString b, QString c)
{
    SalesModel obj1;
    obj1.update(a.toStdString(),b.toStdString(),c.toStdString());
    return 1;
}

int serializer::deleteSaleItem(QString a,QString b,QString c)
{
    SalesModel obj1;
    obj1.removeItem(a.toStdString(),b.toStdString(),c.toStdString());
    return 1;
}

int serializer::deleteSales(QString identifier)
{
    SalesModel obj1;
    obj1.remove(identifier.toStdString());
    return 1;
}

int serializer::loginUser(QString a, QString b)
{
    Authentication obj1;
    if(obj1.error == 1){
        return 0;
    }
    return obj1.authenticate(a.toStdString(), b.toStdString());
}

QString serializer::hashPass(QString a)
{
    Authentication obj;
    return QString::fromUtf8(obj.hashPassword(a.toStdString()).c_str());

}

QString serializer::getOrderCount(QString a)
{
    SalesModel obj1;
    return QString::fromUtf8(obj1.getOrderCount(a.toStdString()).c_str());
}

QString serializer::getRestaurant()
{
    RestaurantModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON().c_str());
}

int serializer::updateRestro(QString a, QString b, QString c)
{
    RestaurantModel obj1;
    obj1.update(a.toStdString(),b.toStdString(),c.toStdString());
    return 1;
}

QString serializer::getDashStats(QString a, QString b)
{
    SalesModel obj1;
    return QString::fromUtf8(obj1.getStatsByDate(a.toStdString(), b.toStdString()).c_str());
}

QString serializer::getBillDetails(QString a)
{
    SalesModel obj1;
    return QString::fromUtf8(obj1.getBillDetails(a.toStdString()).c_str());
}

QString serializer::toBase64(QString a)
{
    Base64 obj(a.toStdString(),Base64::FileMode);
    return QString::fromUtf8(obj.encode().c_str());
}

int serializer::validatePasswordSignUp(QString a)
{
    Authentication obj1;
    return obj1.validatePassword(a.toStdString());
}

int serializer::validateUsernameSignUp(QString a)
{
    Authentication obj1;
    return obj1.validateUsername(a.toStdString());
}

int serializer::passMatch(QString a, QString b)
{
    Authentication obj1;
    return obj1.passwordMatch(a.toStdString(),b.toStdString());
}

void serializer::createBill(QString a)
{
    Bill obj1(a.toStdString());
}

void serializer::printPurchaseBill(QString a)
{
    printBill(a.toStdString());
}

int serializer::checkUsernameExist(QString a)
{
    Authentication obj;
    return obj.checkUsernameExists(a.toStdString());
}

/**
    * @brief: Date Constructor that initlizes a Date object by assigning todayDate, yesterdayDate
    * start and end dates for last week and finally start and end dates for last month
    * @params: null
    * @returns: void
*/
date::date(QObject *parent) : QObject(parent)
{
    stringstream str;
    time_t now = time(0);
    tm *ltm = localtime(&now);
    str << 1900+ltm->tm_year << "-" << 1+ltm->tm_mon << "-" << ltm->tm_mday;
    todayDate = QString::fromUtf8(str.str().c_str());
    setDateYesterday();
    setDateWeek();
    setDateMonth();
}
/**
    * @brief: Function that sets yeterday's Date in yeterdayDate
    * @params: null
    * @returns: void
*/
void date::setDateYesterday()
{
    stringstream d;
    time_t now = time(0);
    tm *date = localtime(&now);
    date->tm_mday -= 1;
    mktime(date);
    d << 1900+date->tm_year << "-" << 1+date->tm_mon << "-" << date->tm_mday;
    yesterdayDate = QString::fromUtf8(d.str().c_str());
}
/**
    * @brief: Function that sets the start and end date for last week
    * @params: null
    * @returns: void
*/
void date::setDateWeek()
{
    int temp;
    stringstream str;
    int f = 1;
    int g = 1;
    time_t now = time(0);
    tm *date = localtime(&now);
    for(;;){
        date->tm_mday -= 1;
        mktime(date);
        temp = date -> tm_wday;
        if(g==0 && f==0){
            break;
        }
        if(temp == 6 && f==1){
            str<<1900+date->tm_year << "-" << 1+date->tm_mon << "-" << date->tm_mday;
            weekEnd = QString::fromUtf8(str.str().c_str());
            str.str(string());
            f=0;
        }
        if(temp == 0 && f==0){
            str<<1900+date->tm_year << "-" << 1+date->tm_mon << "-" << date->tm_mday;
            weekStart = QString::fromUtf8(str.str().c_str());
            str.str(string());
            g=0;
        }
    }
}
/**
    * @brief: Function that sets the start and end date for last month
    * @params: null
    * @returns: void
*/
void date::setDateMonth()
{
    stringstream str;
    int f = 1;
    int cur,temp;
    time_t now = time(0);
    tm *date = localtime(&now);
    date->tm_mday -= 30;
    mktime(date);
    str<<1900+date->tm_year << "-" << 1+date->tm_mon << "-" << "1";
    monthStart = QString::fromUtf8(str.str().c_str());
    str.str(string());
    temp = date->tm_mon;
    for(;;){
        cur = date->tm_mday;
        date->tm_mday += 1;
        mktime(date);
        if(f==0){
            break;
        }
        if(temp != (date->tm_mon)){
            str<<1900+date->tm_year << "-" << 1+temp << "-" << cur;
            monthEnd = QString::fromUtf8(str.str().c_str());
            str.str(string());
            f=0;
        }
    }
}
