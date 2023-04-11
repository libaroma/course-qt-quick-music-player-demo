## 一 项目创建

### 01 项目创建

- 新建Qt Quick 项目
- 修改main.cpp为App.cpp，main.qml为App.qml，相应的App.cpp中代码也需要修改
- 设置窗口尺寸为1200*800

```qml
import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 1200
    height: 800
    visible: true
    title: qsTr("Demo Cloud Music Player")

}
```

### 02 窗体Icon

- 导入images资源

- 资源下载

[图标资源下载](https://files.hyz.cool/files/files/demo_cloud_music_player.zip)

```qml
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    //设置ICON
    app.setWindowIcon(QIcon(":/images/music.png"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

```

