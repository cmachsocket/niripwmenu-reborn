cmake_minimum_required(VERSION 3.16)
project(niripwmenu VERSION 0.1.4 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)

set(QML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/qml")
set(DATA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/data")

qt_add_resources(niripwmenu "niripwmenu"
    PREFIX "/"
    FILES
        "${QML_DIR}/Main.qml"
        "${DATA_DIR}/config.json"
        "${DATA_DIR}/shutdown.png"
        "${DATA_DIR}/reboot.png"
        "${DATA_DIR}/logoff.png"
)

add_executable(niripwmenu
    src/main.cpp
    src/system.cpp
    src/system.h
)

target_link_libraries(niripwmenu PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
)

install(TARGETS niripwmenu RUNTIME DESTINATION bin)
