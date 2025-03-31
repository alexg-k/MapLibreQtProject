#include "Vehicle.hpp"

Vehicle::Vehicle(const std::string& name)
    : name(name)
{
}

Vehicle::~Vehicle() { }

const std::string &Vehicle::getName() const
{
    return name;
}

const std::pair<double, double> Vehicle::getPosition() const
{
    return position;
}

void Vehicle::setPosition(const double latitude, const double longitude)
{
    position = std::make_pair(latitude, longitude);
}
