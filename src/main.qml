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
        MapItemView {
            model: vehicleModel
            delegate: MapQuickItem {
                anchorPoint.x: image.width/2
                anchorPoint.y: image.height/2
                coordinate: model.position
                rotation: model.heading
                sourceItem: Image {
                    id: image
                    source: "qrc:/res/icons/uxv.svg"
                }
                TapHandler {
                    id: tapHandlerVehicleLeft
                    acceptedButtons: Qt.LeftButton
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped: {
                        console.log("Left Tapped: ", model.name);
                    }
                }
                TapHandler {
                    id: tapHandlerVehicleRight
                    acceptedButtons: Qt.RightButton
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped: {
                        console.log("Right Tapped:", model.name);
                        vehicleModel.removeVehicle(model.name);
                    }
                }
            }
        }
        TapHandler {
            id: tapHandlerMapLeft
            gesturePolicy: TapHandler.WithinBounds
            onTapped: (eventPoint) => {
                let coord = map.toCoordinate(eventPoint.position);
                console.log("Tapped at:", coord.latitude, coord.longitude);
                vehicleModel.addVehicle("Test2");
                vehicleModel.setPosition("Test2", coord);
            }
        }
        //MouseArea {
        //    anchors.fill: parent
        //    cursorShape: Qt.CrossCursor
        //    propagateComposedEvents: true
        //}
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
