#include "serializer.h"

serializer::serializer(QObject *parent) : QObject(parent)
{

}

QString serializer::getCategory(){
    MenuCategoryModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON().c_str());
}

QString serializer::getMenuItem(QString a, QString b, QString c)
{
    MenuItemsModel obj1;
    QString ret_val =  QString::fromUtf8(obj1.retrieveJSON(a.toStdString(), b.toStdString(), c.toStdString()).c_str());
    return ret_val;
}

QString serializer::getMenuItem()
{
    MenuItemsModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON().c_str());
}

QString serializer::pkfind(QString a, QString b, QString c)
{
    return QString::fromUtf8(pkFinder(a.toStdString(),b.toStdString(),c.toStdString()).c_str());
}

int serializer::createSales(QString a, QString b)
{
    SalesModel obj;
    return obj.create(a.toStdString(),b.toStdString());
}

QString serializer::getRestaurant()
{
    RestaurantModel obj1;
    return QString::fromUtf8(obj1.retrieveJSON().c_str());
}
