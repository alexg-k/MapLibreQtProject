message(STATUS "Creating AppImage")

set(APPDIR_PATH "${CMAKE_BINARY_DIR}/AppDir")

execute_process(COMMAND linuxdeploy
    --appdir ${APPDIR_PATH}
    --executable ${APPDIR_PATH}/usr/bin/MapLibreQtProject
    --desktop-file ${APPDIR_PATH}/usr/share/applications/MapLibreQtProject.desktop
    --custom-apprun ${CMAKE_BINARY_DIR}/AppRun
    --plugin qt
)
execute_process(COMMAND cp -r /usr/local/plugins/geoservices ${APPDIR_PATH}/usr/plugins/) # bugfix, because maplibre-native-qt or linuxdeploy misses to install this plugin
execute_process(COMMAND linuxdeploy
    --appdir ${APPDIR_PATH}
    --output appimage
)
