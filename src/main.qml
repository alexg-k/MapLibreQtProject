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
    width: Qt.platform.os == "android" ? Screen.width : 640
    height: Qt.platform.os == "android" ? Screen.height : 640
    visible: true
    title: "MapLibreQtProject"

    MapView {
        id: mapview
        anchors.fill: parent

        map.zoomLevel: 5
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
            model: VehicleModel {}
            delegate: vehicleDelegate
        }
        Component {
            id: vehicleDelegate
            MapCircle {
                center: model.position
                radius: 5000.0
                color: 'green'
                border.width: 3
            }
            //MapQuickItem {
            //    coordinate: vehicle.position
            //    anchorPoint: image.center
            //    smooth: true
            //    opacity: 0.8
            //    sourceItem: Image {
            //        Image { id: image; source: "uxv.svg" }
            //        Text { text: vehicle.name; font.bold: true }
            //    }
            //}
            //MouseArea {
            //    id: mouseArea
            //    anchors.fill: parent
            //    hoverEnabled: true
            //    drag.target: parent

            //    //onClicked: {
            //    //    vehicle.clicked(name);
            //    //}
            //}
        }
    }
    //Component.onCompleted: {
    //    VehicleModel.test();
    //}
}