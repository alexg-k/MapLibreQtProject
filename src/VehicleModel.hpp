#ifndef VEHICLE_MANAGER_HPP
#define VEHICLE_MANAGER_HPP 

#include <map>
#include <QAbstractListModel>
#include "Vehicle.hpp"

class VehicleModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit VehicleModel(QObject *parent = nullptr);
    ~VehicleModel();
    void addVehicle(const std::string &name);
    void removeVehicle(const std::string &name);
    Vehicle& getVehicle(const std::string &name);
    enum {
        NameRole = Qt::UserRole,
        PositionRole = Qt::UserRole + 1
    };

signals:
    void sizeChanged(int size);

public slots:
    void test();

public:
    //QListModel
    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    std::map<std::string /*name*/, Vehicle> vehicles;
};

#endif // VEHICLE_MODEL_HPP