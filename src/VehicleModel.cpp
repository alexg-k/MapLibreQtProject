#include "VehicleModel.hpp"
#include <QGeoCoordinate>

VehicleModel::VehicleModel(QObject* parent)
    : QAbstractListModel(parent)
{
    vehicles.emplace_back("Test");
    vehicles.back().setPosition(54.474167, 9.837778);
}

VehicleModel::~VehicleModel() {}

void VehicleModel::addVehicle(const std::string& name)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    vehicles.emplace(name, name);
    endInsertRows();
    emit sizeChanged(vehicles.size());
}

void VehicleModel::removeVehicle(const std::string& name)
{
    for (auto it = vehicles.begin(); it != vehicles.end(); it++)
    {
        if (it->first == name) {
            int row = std::distance(it, vehicles.begin());
            beginRemoveRows(QModelIndex(), row, row);
            vehicles.erase(it);
            endRemoveRows();
            emit sizeChanged(vehicles.size());
            break;
        }
    }
}

Vehicle& VehicleModel::getVehicle(const std::string& name)
{
    return vehicles.at(name);
}

int VehicleModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return vehicles.size();
}

QVariant VehicleModel::data(const QModelIndex& index, int role) const
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
            return QVariant::fromValue(QGeoCoordinate(std::get<0>(it->second.getPosition()), std::get<1>(it->second.getPosition())));
        }
    }
    return QVariant();
}

QHash<int, QByteArray> VehicleModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[PositionRole] = "position";
    return roles;
}
