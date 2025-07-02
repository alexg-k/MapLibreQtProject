import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning
import MapLibre

import VehicleModel 1.0

ApplicationWindow {
    id: mainWindow
    width: Qt.platform.os == "android" ? Screen.width : 1600
    height: Qt.platform.os == "android" ? Screen.height : 1200
    visible: true
    title: "MapLibreQtProject"
    property int vehiclesAdded: 0
    Map {
        id: map
        anchors.fill: parent
        zoomLevel: 10
        center: QtPositioning.coordinate(54.474167, 9.837778)
        plugin: Plugin {
            name: "maplibre"
            PluginParameter {
                name: "maplibre.map.styles"
                value: "https://demotiles.maplibre.org/style.json"
            }
        }
        Text {
            text: "Connected Vehicles: " + vehicleModel.count
            anchors.top: parent.top
            anchors.left: parent.left
            padding: 10
        }
        MapItemView {
            parent: mapview.map
            model: vehicleModel
            delegate: MapQuickItem {
                anchorPoint.x: image.width/2
                anchorPoint.y: image.height/2
                coordinate: model.position
                sourceItem: Row {
                    Image {
                        id: image
                        source: "qrc:/res/icons/uxv.svg"
                        rotation: model.heading
                        width: 32
                        height: 32
                    }
                    Text {
                        text: model.name
                    }
                }
                TapHandler {
                    id: tapHandlerVehicleLeft
                    acceptedButtons: Qt.LeftButton
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped: {
                        console.log("Left tapped the vehicle: ", model.name);
                        vehicleModel.toggleActive(index);
                    }
                }
                TapHandler {
                    id: tapHandlerVehicleRight
                    acceptedButtons: Qt.RightButton
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped: {
                        console.log("Right tapped the vehicle:", model.name);
                        vehicleModel.removeVehicle(index);
                    }
                }
            }
        }
        TapHandler {
            id: tapHandlerMapLeft
            gesturePolicy: TapHandler.WithinBounds
            onTapped: (eventPoint) => {
                let coord = map.toCoordinate(eventPoint.position);
                console.log("Tapped map at:", coord.latitude, coord.longitude);
                vehicleModel.addVehicle("Name" + vehiclesAdded++, coord);
            }
        }
        HoverHandler {
            cursorShape: Qt.CrossCursor
        }
        WheelHandler {
            id: wheel
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
            ? PointerDevice.Mouse | PointerDevice.TouchPad
            : PointerDevice.Mouse
            rotationScale: 1/120
            property: "zoomLevel"
        }
        DragHandler {
            id: drag
            target: null
            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
        }
    }
}
