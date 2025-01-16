# MapLibreQtProject

This is a minimal template project to build a [MapLibre](https://maplibre.org/) / [QtQuick](https://wiki.qt.io/Qt_Quick) / C++ application in a modern build and package environment. For now, only Linux is supported, but more platforms might be added when a contributer requires them. For Linux, the application is then packaged as a portable [AppImage](https://appimage.org/).

## Build and package
### Linux
To build and package, simply run in the project root directory:
1. `cmake -S . -B build`
2. `cmake --build build --target all`
3. `NO_STRIP=true DESTDIR=${PWD}/build/AppDir/ cmake --build build --target install`

You can also make use of a docker container to build, test and package this project. The resulting appimage can then be executed on the host machine. \
`docker compose build`
1. `BUILD_TYPE=Release docker compose run --rm configure`
2. `BUILD_TYPE=Release docker compose run --rm build`
3. `BUILD_TYPE=Release docker compose run --rm package`

A ci/cd workflow for github is also added.