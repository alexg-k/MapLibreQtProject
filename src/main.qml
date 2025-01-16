import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning

import MapLibre 3.0

ApplicationWindow {
    id: mainWindow
    width: Qt.platform.os == "android" ? Screen.width : 640
    height: Qt.platform.os == "android" ? Screen.height : 640
    visible: true
    title: "MapLibreQtProject"

    MapView {
        id: seamarkMap
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
    }

}