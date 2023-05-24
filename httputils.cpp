#include "httputils.h"

HttpUtils::HttpUtils(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    connect(manager,SIGNAL(finished(QNetworkReply*)),this,SLOT(replyFinished(QNetworkReply*)));
}

void HttpUtils::connet(QString url)
{
    QNetworkRequest request;
    request.setUrl(QUrl(BASE_URL+url));
    manager->get(request);
}

void HttpUtils::replyFinished(QNetworkReply *reply)
{
    emit replySignal(reply->readAll());
}
