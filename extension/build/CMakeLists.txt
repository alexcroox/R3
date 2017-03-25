# Run CMake with
# Windows 32bit: `cmake . -G "Visual Studio 14 2015"`
# Windows 64bit: `cmake . -G "Visual Studio 14 2015 Win64"`
# Linux 32bit: `cmake . -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32`
# Linux 64bit: `cmake . -DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64`

# Set this to where the POCO sources are and built
SET(POCO_HOME "c:/dev/c++/poco-poco-1.7.5-release")

# Set this to where the MySQL 32 bit C Connecter was installed 
SET(MYSQL_HOME "c:/Program Files (x86)/MySQL/MySQL Connector C 6.1")
# Set this to where the MySQL 64 bit C Connecter was installed
SET(MYSQL64_HOME "c:/Program Files/MySQL/MySQL Connector C 6.1")

cmake_minimum_required (VERSION 3.2)
PROJECT (r3_extension)

SET(SOURCES
    ../include/extension.h
    ../include/log.h
    ../include/sql.h
    ../src/extension.cpp
    ../src/log.cpp
    ../src/sql.cpp
    ../src/main.cpp
)

IF (CMAKE_SIZEOF_VOID_P EQUAL 8)
    SET(POCO_HOME_LIB ${POCO_HOME}/lib64)
    SET(MYSQL_HOME_LIB ${MYSQL64_HOME}/lib)
    SET(POCO_LINUX_LIB_ARCH "x86_64")
ELSE()
    SET(POCO_HOME_LIB ${POCO_HOME}/lib)
    SET(MYSQL_HOME_LIB ${MYSQL_HOME}/lib)
    SET(POCO_LINUX_LIB_ARCH "x86")
ENDIF()

IF (MSVC)
    # Use static runtime
    foreach(flag_var
            CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
            CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
       if(${flag_var} MATCHES "/MD")
          string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
       endif(${flag_var} MATCHES "/MD")
    endforeach(flag_var)
ELSE()
    SET(POCO_HOME_LIB ${POCO_HOME}/lib/Linux/${POCO_LINUX_LIB_ARCH})
ENDIF()

INCLUDE_DIRECTORIES(../include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Foundation/include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Data/include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Data/MySQL/include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Util/include)

LINK_DIRECTORIES(${POCO_HOME_LIB})

# Console
ADD_EXECUTABLE(r3_extension_console ${SOURCES})
TARGET_COMPILE_DEFINITIONS(r3_extension_console PRIVATE R3_CONSOLE)

# Lib
ADD_LIBRARY(r3_extension SHARED ${SOURCES})

IF (MSVC)
    SET(EXTRA_LIBS)
    SET(STATIC_LIBS
        ${POCO_HOME_LIB}/PocoDatamt.lib
        ${POCO_HOME_LIB}/PocoDataMySQLmt.lib
        ${POCO_HOME_LIB}/PocoFoundationmt.lib
        ${POCO_HOME_LIB}/PocoXMLmt.lib
        ${POCO_HOME_LIB}/PocoJSONmt.lib
        ${POCO_HOME_LIB}/PocoUtilmt.lib
        ${MYSQL_HOME_LIB}/vs14/mysqlclient.lib
    )
ELSE()
    SET(THREADS_PREFER_PTHREAD_FLAG ON)
    FIND_PACKAGE(Threads REQUIRED)

    SET_PROPERTY(TARGET r3_extension_console PROPERTY CXX_STANDARD 11)
    SET_PROPERTY(TARGET r3_extension PROPERTY CXX_STANDARD 11)

    SET(EXTRA_LIBS dl Threads::Threads)
    SET(STATIC_LIBS
        ${POCO_HOME_LIB}/libPocoUtil.a
        ${POCO_HOME_LIB}/libPocoXML.a
        ${POCO_HOME_LIB}/libPocoJSON.a
        ${POCO_HOME_LIB}/libPocoDataMySQL.a
        ${POCO_HOME_LIB}/libPocoData.a
        ${POCO_HOME_LIB}/libPocoFoundation.a
        ${MYSQL_HOME_LIB}/libmysqlclient.a
    )
ENDIF()

TARGET_LINK_LIBRARIES(r3_extension_console ${STATIC_LIBS} ${EXTRA_LIBS})
TARGET_LINK_LIBRARIES(r3_extension ${STATIC_LIBS} ${EXTRA_LIBS})
