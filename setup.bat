mkdir build\admin
mkdir build\customer
robocopy /S %cd%\admin-app %cd%\build\admin
robocopy /S %cd%\customer-app %cd%\build\customer
cd build/admin
qmake RestroPOS-Qt.pro
mingw32-make
cd ../..
copy %cd%\setup\libmysql.dll %cd%\build\admin\release
cd build/customer
qmake CustomerApp-Qt.pro
mingw32-make
cd ../..
copy %cd%\setup\libmysql.dll %cd%\build\customer\release
cd setup
g++ setup.cpp -lmysql
a.exe