#ifndef VEHICLE_MODEL_HPP
#define VEHICLE_MODEL_HPP 

#include <map>
#include <QAbstractListModel>
#include "Vehicle.hpp"

class VehicleModel : public QAbstractListModel
{
    Q_OBJECT
    //Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    explicit VehicleModel(QObject *parent = nullptr);
    ~VehicleModel();
    Vehicle &getVehicle(const QString &name);
    enum {
        NameRole = Qt::UserRole,
        PositionRole = Qt::UserRole + 1,
    };

signals:
    void sizeChanged(int size);

public:
    Q_INVOKABLE void addVehicle(const QString &name);
    Q_INVOKABLE void removeVehicle(const QString &name);

public:
    //QListModel
    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    std::map<QString /*name*/, Vehicle> vehicles;
};

#endif // VEHICLE_MODEL_HPP
