cmake_minimum_required(VERSION 3.12)
project(grtesting)

set(CMAKE_CXX_STANDARD 14)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(gRPC CONFIG REQUIRED)
message("gRPC_DIR ${gRPC_DIR}")

#if (WIN32 AND NOT BUILD_SHARED_LIBS)
#    message(BUILD_SHARED_LIBS: setting win flags)
#    foreach (flag_var
#            CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
#            CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO
#            CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
#            CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
#
#        if (${flag_var} MATCHES "/MD")
#            message("before: ${flag_var}: " ${${flag_var}}"")
#            string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
#            message("after : ${flag_var}: " ${${flag_var}}"")
#        endif ()
#    endforeach ()
#endif ()


add_executable(grtesting
        main.cpp
        )
target_link_libraries(grtesting gRPC::grpc++)
