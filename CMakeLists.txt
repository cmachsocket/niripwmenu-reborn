cmake_minimum_required(VERSION 3.16)
project(niripwmenu_reborn VERSION 0.1.4 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)

add_executable(niripwmenu_reborn
    src/main.cpp
    src/configmanager.cpp
    src/configmanager.h
    niripwmenu_reborn.qrc
)

target_link_libraries(niripwmenu_reborn PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick)

install(TARGETS niripwmenu_reborn RUNTIME DESTINATION bin)