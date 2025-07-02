#include <iostream>
#include "VehicleModel.hpp"
#include <QGeoCoordinate>

VehicleModel::VehicleModel(QObject* parent)
    : QAbstractListModel(parent)
    , running(false)
{
    t = std::thread([&] () {
        running = true;
        while(running) {
            std::this_thread::sleep_for(std::chrono::milliseconds(250));
            emit dataChanged(index(0, 0), index(rowCount() - 1, 0));
        }
    });
}

VehicleModel::~VehicleModel()
{
    running = false;
    if (t.joinable()) 
        t.join();
}

int VehicleModel::getCount() const 
{
    return vehicles.size();
}

void VehicleModel::addVehicle(const QString &name, const QGeoCoordinate& coord)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    vehicles.emplace(name, name.toStdString());
    endInsertRows();
    emit countChanged(vehicles.size());
    vehicles.at(name).setPosition(Coordinate(coord.latitude(), coord.longitude()));
}


void VehicleModel::removeVehicle(int index)
{
    auto it = vehicles.begin();
    std::advance(it, index);
    beginRemoveRows(QModelIndex(), index, index);
    vehicles.erase(it);
    endRemoveRows();
    emit countChanged(vehicles.size());
}

void VehicleModel::setPosition(const QString &name, const QGeoCoordinate &coord)
{
    vehicles.at(name).setPosition(Coordinate(coord.latitude(), coord.longitude()));
    //for (auto it = vehicles.begin(); it != vehicles.end(); it++)
    //{
    //    if (it->first == name) {
    //        int row = std::distance(it, vehicles.begin());
    //        emit dataChanged(index(row, 0), index(row, 0));
    //    }
    //}
}

Vehicle &VehicleModel::getVehicle(const QString &name)
{
    return vehicles.at(name);
}

int VehicleModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    if (parent.isValid())
        return 0;

    return vehicles.size();
}

void VehicleModel::toggleActive(int index)
{
    auto it = vehicles.begin();
    std::advance(it, index);
    it->second.isActive() ? it->second.stop() : it->second.move();
}

QVariant VehicleModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if(index.row() >= 0 && index.row() < vehicles.size())
    {
        auto it = vehicles.begin();
        std::advance(it, index.row());
        switch (role)
        {
        case NameRole:
            return QString::fromStdString(it->second.getName());
        case PositionRole:
            return QVariant::fromValue(QGeoCoordinate(it->second.getPosition().getLatitude(), it->second.getPosition().getLongitude()));
        case HeadingRole:
            return 180.0 / M_PI * it->second.getHeading();
        }
    }
    return QVariant();
}

QHash<int, QByteArray> VehicleModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[PositionRole] = "position";
    roles[HeadingRole] = "heading";
    return roles;
}
