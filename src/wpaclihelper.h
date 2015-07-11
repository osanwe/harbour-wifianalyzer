#ifndef WPACLIHELPER_H
#define WPACLIHELPER_H

#include <QObject>

class WpaCliHelper : public QObject
{
    Q_OBJECT

public:
    explicit WpaCliHelper(QObject *parent = 0);
    virtual ~WpaCliHelper();
    QString getWifiInfo();

signals:
    void onCalledWpaCli();

public slots:
    void callWpaCli();

private:
    QString mWifiInfo;

};

#endif // WPACLIHELPER_H
