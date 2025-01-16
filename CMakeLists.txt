cmake_minimum_required(VERSION 3.24)

### SETUP
project(MapLibreQtProject
    VERSION 1.0
    HOMEPAGE_URL "https://github.com/alexg-k/MapLibreQtProject"
    DESCRIPTION "My template for applications built with cmake"
    LANGUAGES CXX)

find_package(Qt6
    REQUIRED COMPONENTS
        Quick
        Location
        Positioning
)
qt_standard_project_setup(REQUIRES 6.5)
qt_policy(SET QTP0004 NEW)
find_package(QMapLibre COMPONENTS Location REQUIRED)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(QSG_RHI_BACKEND "opengl")
set(QMapLibre_DIR "/usr/local/lib/cmake/QMapLibre")
set(QML_IMPORT_PATH "/usr/local/qml")
set(QT_PLUGIN_PATH "/usr/local/plugins")

## TARGETS
qt_add_executable(${CMAKE_PROJECT_NAME})
add_subdirectory(src/)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Quick Qt6::Location Qt6::Positioning QMapLibre::Location)
qmaplibre_location_setup_plugins(${CMAKE_PROJECT_NAME})

### TEST
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
        NDEBUG
        QT_NO_DEBUG
        QT_NO_DEBUG_OUTPUT
    )
endif()
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    enable_testing()
    add_subdirectory(test/)
endif()

### INSTALL
include(GNUInstallDirs)
include(InstallRequiredSystemLibraries)

install(
    TARGETS ${CMAKE_PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    BUNDLE  DESTINATION .
)

qt_generate_deploy_qml_app_script(
    TARGET ${CMAKE_PROJECT_NAME}
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})

if(LINUX)
    configure_file(
        ${CMAKE_SOURCE_DIR}/pack/linux/${CMAKE_PROJECT_NAME}.desktop.in
        ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.desktop
        @ONLY
    )
        install(
        FILES ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.desktop
        DESTINATION ${CMAKE_INSTALL_DATADIR}/applications/
    )
    configure_file(
        ${CMAKE_SOURCE_DIR}/pack/linux/appimage/AppRun.in
        ${CMAKE_BINARY_DIR}/AppRun
        @ONLY
    )
    install(
        FILES ${CMAKE_SOURCE_DIR}/res/icons/appicon.png
        DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/128x128/apps/
        RENAME icon.png
    )
    set(CMAKE_INSTALL_PREFIX "/usr")
    install(SCRIPT "${CMAKE_SOURCE_DIR}/cmake/CreateAppImage.cmake")
endif()