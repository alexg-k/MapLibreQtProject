#include "Vehicle.hpp"
#include <chrono>
#include <cmath>
#include <iostream>

Vehicle::Vehicle(const std::string& name)
    : name(name)
    , moving(false)
{
}

Vehicle::~Vehicle() {
    stop();
}

const std::string &Vehicle::getName() const
{
    return name;
}

const Coordinate Vehicle::getPosition() const
{
    return position;
}

void Vehicle::setPosition(const Coordinate position)
{
    this->position = position;
}

const double Vehicle::getHeading() const
{
    return heading;
}

void Vehicle::setHeading(const double heading)
{
    this->heading = std::fmod(heading, 2.0 * M_PI); 
}

void Vehicle::move()
{
    if (moving)
        return;
    moving = true;
    Coordinate center = getPosition();
    center.setLongitude(center.getLongitude() - 0.01);
    t = std::thread([&, center] () {
        while(moving) {
            std::this_thread::sleep_for(std::chrono::milliseconds(250));
            setHeading(getHeading() - 0.1);
            setPosition(Coordinate(center.getLatitude() - 0.01 * std::sin(getHeading()), center.getLongitude() + 0.01 * std::cos(getHeading())));
        }
    });
}

void Vehicle::stop()
{
    moving = false;
    if (t.joinable()) {
        t.join();
    }
}

bool Vehicle::isActive()
{
    return moving;
}
