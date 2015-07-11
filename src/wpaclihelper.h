#ifndef WPACLIHELPER_H
#define WPACLIHELPER_H

#include <QObject>
#include <QProcess>

class WpaCliHelper : public QObject
{
    Q_OBJECT

public:
    explicit WpaCliHelper(QObject *parent = 0);
    virtual ~WpaCliHelper();

signals:
    void calledWpaCli();
    void gotScanError();
    void gotResultError();

public slots:
    void callWpaCli();
    QString getWifiInfo();

private:
    QString mWifiInfo;

};

#endif // WPACLIHELPER_H
