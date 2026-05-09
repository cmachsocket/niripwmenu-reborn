cmake_minimum_required(VERSION 3.16)
project(niripwmenu VERSION 0.1.4 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)

set(QML_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/qml/Main.qml
    ${CMAKE_CURRENT_SOURCE_DIR}/data/config.json
    ${CMAKE_CURRENT_SOURCE_DIR}/data/shutdown.png
    ${CMAKE_CURRENT_SOURCE_DIR}/data/reboot.png
    ${CMAKE_CURRENT_SOURCE_DIR}/data/logoff.png
)

qt_add_resources(niripwmenu_resources "niripwmenu" FILES ${QML_SOURCES})

add_executable(niripwmenu
    src/main.cpp
    src/system.cpp
    src/system.h
    ${niripwmenu_resources}
)

target_link_libraries(niripwmenu PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
)

install(TARGETS niripwmenu RUNTIME DESTINATION bin)
