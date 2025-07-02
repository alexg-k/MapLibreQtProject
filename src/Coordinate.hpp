#ifndef COMMON_HPP
#define COMMON_HPP 

#include <iostream>
#include <ostream>

class Coordinate {
private:
    double latitude;
    double longitude;

public:
    Coordinate(double lat = 0.0, double lon = 0.0);
    void setLatitude(double lat);
    void setLongitude(double lon);
    double getLatitude() const;
    double getLongitude() const;
};

#endif // COMMON_HPP
