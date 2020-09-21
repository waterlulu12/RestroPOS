#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QFont>
#include <QQmlEngine>
#include <QQmlContext>
#include "serializer.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Aatish");
    app.setOrganizationDomain("Aatish");
    QScopedPointer<serializer> serializers(new serializer);
    QScopedPointer<date> dates(new date);
    QFont fon("BillCorporate",14);
    app.setFont(fon);
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("sql", serializers.data());
    engine.rootContext()->setContextProperty("qdate", dates.data());
    engine.rootContext()->setContextProperty("yesterdayDate", dates->yesterdayDate);
    engine.rootContext()->setContextProperty("todayDate", dates->todayDate);
    engine.rootContext()->setContextProperty("weekStart", dates->weekStart);
    engine.rootContext()->setContextProperty("weekEnd", dates->weekEnd);
    engine.rootContext()->setContextProperty("monthStart", dates->monthStart);
    engine.rootContext()->setContextProperty("monthEnd", dates->monthEnd);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
