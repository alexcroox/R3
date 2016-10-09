## Dependecies

#### Visual Studio 2013 Express
Download from https://www.microsoft.com/en-us/download/details.aspx?id=44914 . 
Using 2013, becasue build the MySQL C connector with 2015.

#### Visual C++ Redistributable for Visual Studio 2015 x86
Download and install https://www.microsoft.com/en-us/download/details.aspx?id=48145 .

#### MySQL C Connector 32 bit
Download and install the 32 bit C connector for MySQL from https://dev.mysql.com/downloads/connector/c/ .

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
where you've installed the MySQL Connector. Default install directory is `C:\Program Files (x86)\MySQL\MySQL Connector C 6.1`.

Now you should be able build POCO with `.\buildwin.cmd 120 build static_mt both Win32 nosamples notests`.


#### spdlog
Download version `0.10.0` from https://github.com/gabime/spdlog/archive/v0.10.0.zip and 
extract the `spdlog-0.10.0/include/spdlog` directory into `extension/include`.


#### CMake
Download and install version `3.5` or higher from https://cmake.org/download/ . Make sure 
CMake is on the path.

## Building the extension
Before you can build the extension you must first generate the VS solution with CMake.

Update and set `POCO_HOME` and `MYSQL_HOME` in `extension/build/CMakeLists.txt` to match your POCO 
and MySQL directories. Run `cmake . -T "v120"` in `extension/build` directory. Open `r3_extension.sln` 
in Visual Studio.

You will have to build with `Release` configuration and `Win32` platform. `Debug` configuration 
is not part of the tutorial :P .

## Testing and deploying
Just put the `r3_extension.dll` into A3 install directory or into one of the loaded addons folder.

You can also use the console application to test the extension without launching Arma 3.
