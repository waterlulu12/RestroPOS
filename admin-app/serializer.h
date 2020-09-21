#ifndef SERIALIZER_H
#define SERIALIZER_H

#include <QObject>
#include <QString>
#include <sstream>
#include <ctime>
#include "src/models.h"
#include "src/authentication.h"
#include "src/bill.h"

/** Serializer Class
 * @brief: A serializer class to act as a bridge between the User Interface and the primary code
 * 
*/

class serializer : public QObject
{
    Q_OBJECT
public:
    explicit serializer(QObject *parent = nullptr);
    Q_INVOKABLE int createUser(QString,QString);
    Q_INVOKABLE int updateUser(QString,QString,QString);
    Q_INVOKABLE int updateUser(QString,QString,QString,QString);
    Q_INVOKABLE QString getUser(QString,QString,QString);
    Q_INVOKABLE QString getCategory();
    Q_INVOKABLE QString getCategory(QString, QString, QString);
    Q_INVOKABLE QString getMenuItem(QString, QString, QString);
    Q_INVOKABLE QString getMenuItem();
    Q_INVOKABLE int deleteItem(QString);
    Q_INVOKABLE int deleteCategory(QString);
    Q_INVOKABLE int updateCategory(QString, QString, QString);
    Q_INVOKABLE int updateItem(QString, QString, QString, QString);
    Q_INVOKABLE int updateItem(QString, QString, QString, QString, QString);
    Q_INVOKABLE QString pkfind(QString,QString,QString);
    Q_INVOKABLE int createMenuItem(QString,QString, QString);
    Q_INVOKABLE int createCategory(QString);
    Q_INVOKABLE QString getSales(QString);
    Q_INVOKABLE QString getSalesBound();
    Q_INVOKABLE QString getSalesByDate(QString, QString);
    Q_INVOKABLE QString getIDetails(QString);
    Q_INVOKABLE int submitBillButton(QString,QString,QString);
    Q_INVOKABLE int deleteSaleItem(QString,QString,QString);
    Q_INVOKABLE int deleteSales(QString);
    Q_INVOKABLE int loginUser(QString, QString);
    Q_INVOKABLE QString hashPass(QString);
    Q_INVOKABLE QString getOrderCount(QString);
    Q_INVOKABLE QString getRestaurant();
    Q_INVOKABLE int updateRestro(QString,QString,QString);
    Q_INVOKABLE QString getDashStats(QString,QString);
    Q_INVOKABLE QString getBillDetails(QString);
    Q_INVOKABLE QString toBase64(QString);
    Q_INVOKABLE int validatePasswordSignUp(QString);
    Q_INVOKABLE int validateUsernameSignUp(QString);
    Q_INVOKABLE int passMatch(QString, QString);
    Q_INVOKABLE void createBill(QString);
    Q_INVOKABLE void printPurchaseBill(QString);
    Q_INVOKABLE int checkUsernameExist(QString);


signals:

};


class date : public QObject{
    Q_OBJECT
    public:
        QString weekStart,weekEnd,monthStart,monthEnd,yesterdayDate,todayDate;
        explicit date(QObject *parent = nullptr);
        Q_INVOKABLE void setDateYesterday();
        Q_INVOKABLE void setDateWeek();
        Q_INVOKABLE void setDateMonth();

    signals:
};

#endif // SERIALIZER_H
