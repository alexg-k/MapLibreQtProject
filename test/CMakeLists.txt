include(CTest)

add_executable(myTest test.cpp)

add_test(NAME myTest COMMAND myTest)