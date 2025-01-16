#include <string>
#include <utility>

class Vehicle
{
private:
    std::string name;
    std::pair<double, double> position;

public:
    Vehicle(const std::string &name);
    ~Vehicle();
    const std::string& getName() const;
    const std::pair<double, double> getPosition() const;
    void setPosition(const double latitude, const double longitude);
};