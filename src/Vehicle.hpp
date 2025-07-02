#ifndef VEHICLE_HPP
#define VEHICLE_HPP 

#include <string>
#include <utility>
#include <thread>

#include "Coordinate.hpp"

class Vehicle
{

private:
    std::string name;
    Coordinate position;
    double heading;
    std::thread t;
    bool moving;

public:
    Vehicle(const std::string &name);
    ~Vehicle();
    const std::string& getName() const;
    const Coordinate getPosition() const;
    void setPosition(const Coordinate coord);
    const double getHeading() const;
    void setHeading(const double heading);
    void move();
    void stop();
    bool isActive();
};
#endif // VEHICLE_HPP
