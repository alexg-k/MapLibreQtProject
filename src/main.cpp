#include <QGuiApplication>
#include <QQmlApplicationEngine>
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
#include <QQuickWindow>
#endif

#include "VehicleModel.hpp"

int main(int argc, char** argv)
{
    #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGLRhi);
    #endif

    const QGuiApplication app(argc, argv);

    qmlRegisterType<VehicleModel>("VehicleModel", 1, 0, "VehicleModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}