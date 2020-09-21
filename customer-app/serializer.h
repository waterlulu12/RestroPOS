#ifndef SERIALIZER_H
#define SERIALIZER_H

#include <QObject>
#include <QString>
#include "src/models.h"
#include "src/authentication.h"

class serializer : public QObject
{
    Q_OBJECT
public:
    explicit serializer(QObject *parent = nullptr);

    Q_INVOKABLE QString getCategory();
    Q_INVOKABLE QString getMenuItem(QString, QString, QString);
    Q_INVOKABLE QString getMenuItem();
    Q_INVOKABLE QString pkfind(QString,QString,QString);
    Q_INVOKABLE int createSales(QString,QString);
    Q_INVOKABLE QString getRestaurant();

};

#endif // SERIALIZER_H
