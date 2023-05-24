## 四 音乐搜索服务

### 16 Docker安装

#### 1.下载

[【地址】](https://docs.docker.com/desktop/install/windows-install/)

#### 2.安装

直接安装即可

#### 3.开启Hyper-V虚拟服务

```shell
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V-All /LimitAccess /ALL
```
- 将上面的内容复制到文本文件中
- 然后将文件命名为Hyper-V.cmd
- 右键运行
- 然后重启
- 然后打开程序与功能
- 开启Hyper-v

#### 4.更新wsl

如果弹窗说需要更新wsl，那么需要进入下面这个地址里面，按照第四个步骤进行更新即可
[【地址】](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)

#### 5.登陆

需要注册账号，并登录

### 17 Docker部署云音乐api服务

[网易云音乐 NodeJS 版 API (neteasecloudmusicapi.js.org)](https://neteasecloudmusicapi.js.org/#/)

#### 1.镜像下载

```shell
docker pull https://neteasecloudmusicapi.js.org
```

#### 2.运行容器

```shell
docker run -d -p 3000:3000 --name music binaryify/netease_cloud_music_api
```

#### 3.查看运行的容器

```shell
docker ps
```

#### 4.停止运行的容器

```shell
docker stop 容器名称
```

#### 5.运行停止的容器

```shell
docker start 容器名称
```

#### 6.删除容器

需要先停止运行，然后

```shell
docker rm 容器名称
```

#### 7.查看镜像列表

```shell
docker images
```

#### 8.删除镜像

```shell
docker rmi 镜像id
```

### 18 网络请求

- HttpUtils.h

```c++
//HttpUtils.h

#ifndef HTTPUTILS_H
#define HTTPUTILS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class HttpUtils : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtils(QObject *parent = nullptr);
    ~HttpUtils();

    Q_INVOKABLE void connect(QString url);
    Q_INVOKABLE void replyFinished(QNetworkReply* reply);

signals:
 void replySignal(QString reply);

private:
    QNetworkAccessManager *manager;
    QString BASE_URL="http://localhost:3000/api/";

};

#endif // HTTPUTILS_H
```

- HttpUtils.cpp

```c++
//HttpUtils.cpp

#include "httputils.h"
#include <QDebug>
#include <QNetworkReply>

HttpUtils::HttpUtils(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    QObject::connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));
}

void  HttpUtils::connect(QString url){
    QNetworkRequest request;
    request.setUrl(QUrl(BASE_URL+url));
    manager->get(request);
}

void HttpUtils::replyFinished(QNetworkReply* reply){
    QString result =reply->readAll();
    emit replySignal(result);
}

HttpUtils::~HttpUtils(){
    delete manager;
}
```

- App.cpp

```c++
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>
#include <QDebug>
#include "src/httputils.h"

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    //参数：qmlRegisterType<C++类型名> (命名空间 主版本 次版本 QML中的类型名)
    qmlRegisterType<HttpUtils>("MyUtils",1,0,"HttpUtils");

	...
}
```

- App.qml

```qml
//App.qml

import MyUtils 1.0

ApplicationWindow {

   ...

    HttpUtils{
        id:http
    }
    
    ...
    
    Component.onCompleted: {
        textHttp()
    }

    function textHttp(){
        function onReply(reply){
        	console.log(reply)
            http.onReplySignal.disconnect(onReply)
        }
        http.onReplySignal.connect(onReply)
        http.connect("banner")
    }
    
}
```







