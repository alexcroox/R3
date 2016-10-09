# Generate with: cmake . -G "Visual Studio 12 2013"

# Set this to where the POCO sources are and built
SET(POCO_HOME "c:/dev/c++/poco-1.7.5-all")

# Set this to where the MySQL C Connecter was installed 
SET(MYSQL_HOME "c:/Program Files (x86)/MySQL/MySQL Connector C 6.1")



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

INCLUDE_DIRECTORIES(../include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Foundation/include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Data/include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Data/MySQL/include)
INCLUDE_DIRECTORIES(${POCO_HOME}/Util//include)

LINK_DIRECTORIES(${POCO_HOME}/lib)

# Use static runtime
foreach(flag_var
        CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
   if(${flag_var} MATCHES "/MD")
      string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
   endif(${flag_var} MATCHES "/MD")
endforeach(flag_var)

# Console
ADD_EXECUTABLE(r3_extension_console ${SOURCES})
TARGET_COMPILE_DEFINITIONS(r3_extension_console PRIVATE R3_CONSOLE)

# DLL
ADD_LIBRARY(r3_extension SHARED ${SOURCES})


SET(STATIC_LIBS
    ${POCO_HOME}/lib/PocoDatamt.lib
    ${POCO_HOME}/lib/PocoDataMySQLmt.lib
    ${POCO_HOME}/lib/PocoFoundationmt.lib
    ${POCO_HOME}/lib/PocoXMLmt.lib
    ${POCO_HOME}/lib/PocoJSONmt.lib
    ${POCO_HOME}/lib/PocoUtilmt.lib
    ${MYSQL_HOME}/lib/vs12/mysqlclient.lib
)

TARGET_LINK_LIBRARIES(r3_extension_console ${STATIC_LIBS})
TARGET_LINK_LIBRARIES(r3_extension ${STATIC_LIBS})
