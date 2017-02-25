CMAKE_MINIMUM_REQUIRED(VERSION 2.8.9)

#When it was released, cork required clang, but I have been able to compile it with GCC 5.3.1

#In principle, cork can be compiled in Visual Studio with MPIR as a replacement for GMP,
#but there were issues with MPIR that do not seem to have been solved: https://github.com/gilbo/cork/issues/15
#so, we fail fast if using a Visual studio generator

if(MSVC)
  message(FATAL_ERROR "Error: compiling cork in Visual Studio is possible but not supported with this file (cork/CMakeLists.txt). Feel free to modify the file if you know what you are doing!!!!")
endif()

message("->CORK REQUIRES GMP COMPILED WITH C++ SUPPORT. PLEASE, MAKE SURE THAT GMP HEADER AND LIBRARIES ARE IN THEIR EXPECTED LOCATIONS")
#find_library is inducing errors in mingw and debian stretch, so we just hope gmp is installed and reachable...
set(GMP_INCLUDE_DIR "" CACHE PATH "INCLUDE DIRECTORY FOR GMP")
set(GMP_LIBRARY_CXX "gmpxx" CACHE STRING "GMP C++ LIBRARY")
set(GMP_LIBRARY_C   "gmp" CACHE STRING "GMP C   LIBRARY")

set(SRC ${CMAKE_CURRENT_SOURCE_DIR}/src)

PROJECT(cork)

if (NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE "Release" CACHE STRING "Release type")
endif()

set(ADDITIONAL_FLAGS "-Wall -O2")

set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} ${ADDITIONAL_FLAGS}) 
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "${ADDITIONAL_FLAGS} -std=c++11") 

set(INCLUDE_DIRS ${GMP_INCLUDE_DIR} ${SRC} ${SRC}/accel ${SRC}/file_formats ${SRC}/isct ${SRC}/math ${SRC}/mesh ${SRC}/rawmesh ${SRC}/util)
include_directories(${INCLUDE_DIRS})

set(triangle_source ${SRC}/isct/triangle.c)

set(cork_sources
    ${SRC}/file_formats/files.cpp
    ${SRC}/file_formats/ifs.cpp
    ${SRC}/file_formats/off.cpp
    ${SRC}/file_formats/ifs.cpp
    ${SRC}/isct/empty3d.cpp
    ${SRC}/isct/quantization.cpp
    ${SRC}/util/log.cpp
    ${SRC}/util/timer.cpp
    ${SRC}/cork.cpp
    ${SRC}/main.cpp
    )

set_property(SOURCE ${triangle_source} APPEND PROPERTY COMPILE_DEFINITIONS NO_TIMER REDUCED CDT_ONLY TRILIBRARY ANSI_DECLARATORS)

ADD_EXECUTABLE(cork ${triangle_source} ${cork_sources})
target_link_libraries(cork ${GMP_LIBRARY_CXX} ${GMP_LIBRARY_C})

set_property(TARGET cork APPEND PROPERTY LINK_FLAGS "-DNDEBUG")
