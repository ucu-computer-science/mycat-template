cmake_minimum_required(VERSION 3.15)
project(mycat
        VERSION 1.0.0
        DESCRIPTION "Read files to stdout"
        HOMEPAGE_URL "https://github.com/chernetskyi/mycat-template"
        LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Options
option(WARNINGS_AS_ERRORS   "Treat compiler warnings as errors."    ON)
option(ENABLE_CONAN         "Use Conan as a package manager."       OFF)
option(ENABLE_PVS_STUDIO    "Use PVS-Studio static code analyzer."  OFF) # Option for the local usage only. PVS-Studio isn't installed on GitHub machines.
option(ENABLE_SANITIZERS    "Use sanitizers to detect errors."      OFF) # Option for the test builds. Do not use it in the production builds.

# Project source compilation
include_directories(inc)
add_library(cat STATIC
            src/cat/cat.cpp inc/cat/cat.hpp)
add_executable(mycat src/main.cpp)
target_link_libraries(mycat cat)

# Add external packages
set(Boost_USE_STATIC_LIBS ON)
find_package(Boost 1.71.0 COMPONENTS program_options REQUIRED)
include_directories(${Boost_INCLUDE_DIR})
target_link_libraries(mycat Boost::program_options)

# Define ALL_TARGETS variable to use in some directives
set(ALL_TARGETS cat mycat)

# Include default CMake configuration
include(cmake/Config.cmake)
