cmake_minimum_required(VERSION 3.16)

# Copyright (C) 2025 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

project(niripwmenu VERSION 0.1.4 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.11 REQUIRED Core Gui Qml Quick QuickControls2)
find_program(QSB_EXECUTABLE qsb HINTS "/usr/lib/qt6/bin/")

qt_standard_project_setup(REQUIRES 6.11)

# Build executable
qt_add_executable(niripwmenu-bin
    src/main.cpp
    src/configmanager.cpp
    src/configmanager.h
)

# QML module as STATIC library (its objects embed into niripwmenu-bin at link time)
qt_add_qml_module(niripwmenu
    URI niripwmenu
    QML_FILES
        src/qml/Main.qml
        src/qml/Style.qml
)

# Data files (add resources directly to the executable target)
qt_add_resources(niripwmenu-bin "data_qrc"
    PREFIX "/data"
    FILES
        data/config.json
        data/shutdown.png
        data/reboot.png
        data/logoff.png
)

# Bundle qmldir into executable
qt_add_resources(niripwmenu-bin "qmldir_bundle"
    PREFIX "/qt/qml/niripwmenu/"
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/qmldir
)

target_link_libraries(niripwmenu-bin PRIVATE
    Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2
)

# Force-include ALL objects from the static niripwmenu library
# --whole-archive is needed because linker discarding "unused" archive members
target_link_options(niripwmenu-bin PRIVATE
    -Wl,--whole-archive
    $<TARGET_FILE:niripwmenu>
    -Wl,--no-whole-archive
)

install(TARGETS niripwmenu-bin
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET niripwmenu-bin
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
