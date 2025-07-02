#ifndef VEHICLE_MODEL_HPP
#define VEHICLE_MODEL_HPP 

#include <map>
#include <thread>
#include <QAbstractListModel>
#include <QGeoCoordinate>
#include "Vehicle.hpp"
#include "Coordinate.hpp"

class VehicleModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount NOTIFY countChanged)

public:
    explicit VehicleModel(QObject *parent = nullptr);
    ~VehicleModel();
    Vehicle &getVehicle(const QString &name);
    int getCount() const;
    enum {
        NameRole = Qt::UserRole,
        PositionRole = Qt::UserRole + 1,
        HeadingRole = Qt::UserRole + 2,
    };

signals:
    void countChanged(int size);

public:
    Q_INVOKABLE void addVehicle(const QString &name, const QGeoCoordinate& coord = QGeoCoordinate());
    Q_INVOKABLE void removeVehicle(int index);
    Q_INVOKABLE void setPosition(const QString &name, const QGeoCoordinate &coord);
    Q_INVOKABLE void toggleActive(int index);

public:
    //QListModel
    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    std::map<QString /*name*/, Vehicle> vehicles;
    std::thread t;
    bool running;
};

#endif // VEHICLE_MODEL_HPP
