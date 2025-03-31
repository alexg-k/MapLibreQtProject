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
    MapView {
        id: mapview
        anchors.fill: parent
        map.zoomLevel: 10
        map.center: QtPositioning.coordinate(54.474167, 9.837778)
        map.plugin: Plugin {
            name: "maplibre"
            PluginParameter {
                name: "maplibre.map.styles"
                value: "https://demotiles.maplibre.org/style.json"
            }
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
        }
        MapItemView {
            parent: mapview.map
            model: vehicleModel
            delegate: MapCircle {
                center: model.position
                radius: 500.0
                color: 'green'
                border.width: 3
                TapHandler {
                    id: tapHandlerRight
                    acceptedButtons: Qt.RightButton
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped: {
                        vehicleModel.removeVehicle(model.name);
                    }
                }
            }
        }
        TapHandler {
            id: tapHandlerLeft
            //gesturePolicy: TapHandler.WithinBounds
            onTapped: {
                vehicleModel.addVehicle("Test2");
            }
        }
    }
}
