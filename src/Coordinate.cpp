#include "Coordinate.hpp"
#include <iostream>

Coordinate::Coordinate(double lat, double lon)
{
    setLatitude(lat);
    setLongitude(lon);    
}

void Coordinate::setLatitude(double lat)
{
    if (lat >= -90.0 && lat <= 90.0)
        latitude = lat;
    else {
        latitude = 0.0;
        std::cerr << "Invalid latitude: (" << lat << ")! Must be between -90 and 90. " << std::endl;
    }
}

void Coordinate::setLongitude(double lon)
{
    if (lon >= -180.0 && lon <= 180.0)
        longitude = lon;
    else {
        longitude = 0.0;
        std::cerr << "Invalid longitude: (" << lon << ")! Must be between -180 and 180." << std::endl;
    }
}

double Coordinate::getLatitude() const
{
    return latitude;
}

double Coordinate::getLongitude() const
{
    return longitude;
}

