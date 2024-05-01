cmake_minimum_required(VERSION 3.14)

project(AutoSimulateGui VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Widgets Concurrent)
find_package(OpenCV REQUIRED)

file(GLOB PROJECT_HEADERS "src/cpp/header/*.h")
file(GLOB PROJECT_SOURCES "src/cpp/src/*.cpp")

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(AutoSimulateGui
            MANUAL_FINALIZATION
            src/cpp/src/main.cpp
            ${PROJECT_HEADERS}
            ${PROJECT_SOURCES}
            qml.qrc
            D:/qtproj/QHotkey/QHotkey/qhotkey.cpp
            D:/qtproj/QHotkey/QHotkey/qhotkey_win.cpp
            src/cpp/header/log_model.h
            src/cpp/src/log_model.cpp
            src/cpp/header/function_controller.h
            src/cpp/src/function_controller.cpp
        )
else()
    if(ANDROID)
        add_library(AutoSimulateGui SHARED
                src/cpp/src/main.cpp
                ${PROJECT_HEADERS}
                ${PROJECT_SOURCES}
        )
    else()
        add_executable(AutoSimulateGui
                src/cpp/src/main.cpp
                ${PROJECT_HEADERS}
                ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(AutoSimulateGui
        PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Concurrent
        ${OpenCV_LIBS}
)

if(${QT_VERSION} VERSION_LESS 6.1.0)
    set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.AutoSimulateGui)
endif()
set_target_properties(AutoSimulateGui PROPERTIES
        ${BUNDLE_ID_OPTION}
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
include_directories("src/cpp/header")
include_directories("D:/qtproj/QHotkey/QHotkey")
install(TARGETS AutoSimulateGui
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(AutoSimulateGui)
    qt_finalize_executable(AutoSimulateGui)
endif()
