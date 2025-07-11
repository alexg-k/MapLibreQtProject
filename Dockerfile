FROM debian:trixie
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG QT_VERSION=6.9.0
ARG QT_PATH=/opt/Qt

# Install system packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    locales \
    patchelf \
    file \
    sudo \
    wget  \
    git \
    build-essential \
    cmake  \
    # neovim \
    tmux

# Create user
RUN groupadd --gid $USER_GID $USERNAME && \
    adduser --disabled-password  --uid $USER_UID --gid $USER_GID $USERNAME && \
    adduser $USERNAME sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8   

# Install qt6
RUN apt-get install -y \
    python3 \
    git \
    ccache \
    curl \
    ninja-build \
    qt6-wayland \
    libgl1-mesa-dev \
    libfontconfig1-dev \
    libfreetype-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxcb-cursor-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shape0-dev \
    libxcb-shm0-dev \
    libxcb-sync-dev \
    libxcb-util-dev \
    libxcb-xfixes0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb1-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrender-dev \
    libicu-dev \
    libvulkan-dev \
    libqt6sql6-mysql \
    libssl-dev
    
RUN apt-get install -y python3-pip python3-venv
RUN python3 -m venv /opt/venv
RUN . /opt/venv/bin/activate && pip3 install --no-cache-dir aqtinstall
RUN . /opt/venv/bin/activate && aqt install-qt -O "$QT_PATH" linux desktop "$QT_VERSION" linux_gcc_64 --modules qtlocation qtpositioning qtmultimedia
ENV QT_ROOT_DIR="$QT_PATH/${QT_VERSION}/gcc_64/"
ENV PATH="${PATH}:${QT_ROOT_DIR}/bin"

# Install maplibre-native-qt
ENV QT_QPA_PLATFORM="xcb"
ENV QSG_RHI_BACKEND="opengl"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib:${QT_ROOT_DIR}/lib"
ENV QMapLibre_DIR="/usr/local/lib/cmake/QMapLibre"
ENV QML_IMPORT_PATH="/usr/local/qml"
ENV QT_PLUGIN_PATH="/usr/local/plugins"
RUN git clone https://github.com/maplibre/maplibre-native-qt.git && \
    cd maplibre-native-qt && \
    git submodule update --init --recursive
# workaround: remove tests while building
RUN sed -i '217,220d' /maplibre-native-qt/cmake/presets/Linux.json 
RUN sed -i 's/3.5.1/3.10/' /maplibre-native-qt/vendor/maplibre-native/vendor/mapbox-base/CMakeLists.txt 
RUN cd /maplibre-native-qt && cmake --workflow --preset Linux-ccache
RUN cd /build/qt6-Linux/ && ninja install

# Setup packaging environment
RUN apt-get install -y \
    file \
    patchelf \
    libgpgme-dev \
    libgcrypt20-dev \
    libglib2.0-dev \
    libjpeg-dev \
    libgtest-dev \
    cimg-dev \
    libgmock-dev \
    squashfs-tools \
    desktop-file-utils \
    zsync \
    appstream
RUN git clone https://github.com/linuxdeploy/linuxdeploy.git && \
    cd linuxdeploy/ && \
    git submodule update --init --recursive && \
    cmake -S . -B build && \
    cmake --build build && \
    cmake --install build && \
    cd / && rm -rf linuxdeploy/
RUN git clone https://github.com/linuxdeploy/linuxdeploy-plugin-qt && \
    cd linuxdeploy-plugin-qt/ && \
    git submodule update --init --recursive && \
    cmake -S . -B build && \
    cmake --build build && \
    cmake --install build && \
    cd / && rm -rf linuxdeploy-plugin-qt/
RUN git clone https://github.com/linuxdeploy/linuxdeploy-plugin-appimage.git && \
    cd linuxdeploy-plugin-appimage/ && \
    git submodule update --init --recursive && \
    cmake -S . -B build && \
    cmake --build build && \
    cmake --install build && \
    cd / && rm -rf linuxdeploy-plugin-appimage/
RUN git clone https://github.com/AppImage/appimagetool && \
    cd appimagetool/ && \
    git submodule update --init --recursive && \
    cmake -S . -B build && \
    cmake --build build && \
    cmake --install build && \
    cd / && rm -rf appimagetool

# install neovim from source because apt version throws errors with modern plugins
RUN apt install -y make gcc ripgrep unzip git xclip curl nodejs && \
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    mkdir -p /opt/nvim-linux-x86_64 && \
    chmod a+rX /opt/nvim-linux-x86_64 && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/ && \
    rm -rf nvim-linux-x86_64.tar.gz && \
    curl -LO https://github.com/tree-sitter/tree-sitter/releases/download/v0.25.6/tree-sitter-linux-x64.gz && \
    gunzip tree-sitter-linux-x64.gz && \
    chmod +x tree-sitter-linux-x64 && \
    mv tree-sitter-linux-x64 /usr/bin/tree-sitter

RUN apt-get clean
USER $USERNAME
WORKDIR /project
CMD ["/bin/bash"]
ARG BUILD_TYPE=Debug

# install neovim config and plugins for dev environment
RUN git clone https://github.com/alexg-k/kickstart.nvim.git ~/.config/nvim
RUN nvim --headless "+Lazy! sync" +qa
RUN nvim --headless "+Lazy! update" +qa 
RUN nvim --headless "+Lazy! install" +qa
RUN nvim "+Lazy! install" +MasonToolsInstallSync +q!

