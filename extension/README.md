# Windows

## Dependecies

#### Visual Studio 2015 Express
Download from https://www.microsoft.com/en-us/download/details.aspx?id=48146 . 

#### MySQL C Connector
Download and install the C connector for MySQL from https://dev.mysql.com/downloads/connector/c/ .
Tested with version 6.1 .

Choose the architecture you want to build, you can only install one. To have both 32 and 64 bit 
installed, you will have to install the 64 bit using the MSI and install the 32 bit using the zip 
distribution.


#### POCO C++
Download version `1.7.5` source from https://pocoproject.org/releases/poco-1.7.5/poco-1.7.5-all.zip .
Extract the archive somewhere, we will be referencing this folder as `POCO_HOME`.
You will need to build the following POCO components:
```
Foundation
XML
JSON
Util
Data
Data/MySQL
```
Edit `POCO_HOME/components` file and overwrite it with the code above.

Next we need to tell POCO where to find the MySQL includes in `POCOHOME/buildwin.cmd`. Find the 
line that looks like `set MYSQL_DIR=C:\PROGRA~1\MySQL\MYSQLS~1.5` and replace the path with 
where you've installed the MySQL Connector. Default install directory 
for 32 bit is `C:\Program Files (x86)\MySQL\MySQL Connector C 6.1`, 
for 64 bit it's `C:\Program Files\MySQL\MySQL Connector C 6.1`.
You must use the same MySQL architecture you are building POCO in!

Now you should be able build POCO for 32bit with `.\buildwin.cmd 140 build static_mt both Win32 nosamples notests`.
For 64bit with `.\buildwin.cmd 140 build static_mt both x64 nosamples notests`.


#### spdlog
Download version `0.10.0` from https://github.com/gabime/spdlog/archive/v0.10.0.zip and 
extract the `spdlog-0.10.0/include/spdlog` directory into `extension/include`.


#### CMake
Download and install version `3.5` or higher from https://cmake.org/download/ . Make sure 
CMake is on the path.




# Linux

This has been tested on Ubuntu 16.04 LTS with GCC 5.4.0

## Dependecies

#### MySQL C Connector
Download the correct architecture you want to build for and extract the C connector for MySQL from https://dev.mysql.com/downloads/connector/c/ .
Extract the archive somewhere, we will be referencing this folder as `MYSQL_HOME`.


#### CMake
Download and install version `3.5` or higher from https://cmake.org/download/ or just run `sudo apt-get install cmake`

#### POCO C++
Download version `1.7.5` source from https://pocoproject.org/releases/poco-1.7.5/poco-1.7.5-all.zip .
Extract the archive somewhere, we will be referencing this folder as `POCO_HOME`.

Install 32bit and 64bit libraries for GCC with `sudo apt-get install gcc-multilib g++-multilib`

Only for 32 bit, create file `$POCO_HOME/build/config/Linux32-gcc` with the content below
```
#
# $Id: //poco/1.4/build/config/Linux#2 $
#
# Linux
#
# Make settings for crossbuilding Poco Linux x86 on a Linux x86_64 OS.
#
#

include $(POCO_BASE)/build/config/Linux

#
# Crossbuild Settings
#
POCO_TARGET_OSNAME  = Linux
POCO_TARGET_OSARCH  = x86

#
# Compiler and Linker Flags
#
CFLAGS64        += -m32
CXXFLAGS64      += -m32
SHLIBFLAGS64    += -m32
LINKFLAGS64 += -m32

CFLAGS32        += -m32
CXXFLAGS32      += -m32
SHLIBFLAGS32    += -m32
LINKFLAGS32 += -m32
```

Replace `$MYSQL_HOME` in `--include-path` and `--library-path` options below where you have extracted the MySQL C Connector 
and run the command for 32bit
`./configure --config=Linux32-gcc --static --shared --no-samples --no-tests --include-path=$MYSQL_HOME/include --library-path=$MYSQL_HOME/lib --omit=CppUnit,CppUnit/WinTestRunner,Net,Crypto,NetSSL_OpenSSL,NetSSL_Win,Data/SQLite,Data/ODBC,Zip,PageCompiler,PageCompiler/File2Page,PDF,CppParser,MongoDB,PocoDoc,ProGen`
or for 64 bit
`./configure --config=Linux --static --shared --no-samples --no-tests --cflags=-fPIC --include-path=$MYSQL_HOME/include --library-path=$MYSQL_HOME/lib --omit=CppUnit,CppUnit/WinTestRunner,Net,Crypto,NetSSL_OpenSSL,NetSSL_Win,Data/SQLite,Data/ODBC,Zip,PageCompiler,PageCompiler/File2Page,PDF,CppParser,MongoDB,PocoDoc,ProGen`

Now you can build with `make`


#### spdlog
Download version `0.10.0` from https://github.com/gabime/spdlog/archive/v0.10.0.zip and 
extract the `spdlog-0.10.0/include/spdlog` directory into `extension/include`.



## Building the extension

Update and set `POCO_HOME` and `MYSQL_HOME` in `extension/build/CMakeLists.txt` to match your POCO and MySQL directories.

### Windows

For 32bit run `cmake . -G "Visual Studio 14 2015"`, for 64bit run `cmake . -G "Visual Studio 14 2015 Win64"` 
in `extension/build` directory. Open `r3_extension.sln` in Visual Studio.

You will have to build with `Release` configuration and `Win32` platform. `Debug` configuration 
is not part of the tutorial :P .

### Linux

For 32bit run `cmake . -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32`, 
for 64bit run `cmake . -DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64` in extension/build directory.

Now you can run make to build the extension with `make`.



## Testing and deploying
Just put the `r3_extension.dll` into A3 install directory or into one of the loaded addons folder.

You can also use the console application to test the extension without launching Arma 3.
