cmake_minimum_required(VERSION 3.7)
project(ircsrv C CXX)

find_package (Threads)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

find_package(Git QUIET)
set (VCS_REVISION "-1")
if(GIT_FOUND)
    include(GetGitRevisionDescription)
    get_git_head_revision(GIT_REFSPEC GIT_SHA1)
    message(STATUS "GIT branch ${GIT_REFSPEC}")
    message(STATUS "GIT revision ${GIT_SHA1}")
    set (VCS_REVISION ${GIT_SHA1})
endif()

include(ccache)
include(zlib)
include(protobuf)
include(sqlite)
include(grpc)
include(paho)
include(flatbuffers)


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

set(VERSION_MAJOR "0")
set(VERSION_MINOR "0")
set(VERSION_PATCH "0")
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

add_subdirectory(include)

set(ircsrv_SOURCE_DIR ${PROJECT_SOURCE_DIR}/src)

set(ircsrv_LIBRARIES 
    ${zlib_STATIC_LIBRARIES}
    ${protobuf_STATIC_LIBRARIES}
    ${sqlite_STATIC_LIBRARIES}
    ${grpc_STATIC_LIBRARIES}
    ${flatbuffers_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT}
)

message("IRCSRV ${ircsrv_LIBRARIES}")

set(ircsrv_DEPENDENCIES
    zlib_copy_headers_to_destination
    protobuf
    sqlite_copy_headers_to_destination
    grpc
    flatbuffers
    ircsrv_flatbuffers
)

include_directories(
    # Source and generated code.
    ${ircsrv_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}/include
    # External dependencies.
    ${zlib_INCLUDE_DIR}
    ${PROTOBUF_INCLUDE_DIRS}
    ${sqlite_INCLUDE_DIR}
    ${GRPC_INCLUDE_DIRS}
    ${flatbuffers_INCLUDE_DIR}
)

set(ircsrv_SOURCES
    ${PROJECT_SOURCE_DIR}/src/main.cpp
)

function(add_flatbuffer TARGET FBS_SOURCE)
    string(REGEX REPLACE "\\.fbs$" "_generated.h" GENERATED_HEADER ${FBS_SOURCE})
    add_custom_command(
        OUTPUT ${GENERATED_HEADER}
	COMMAND ${flatbuffers_GENERATOR} --cpp --grpc --gen-mutable -o "${CMAKE_CURRENT_BINARY_DIR}/include" "${CMAKE_CURRENT_SOURCE_DIR}/${FBS_SOURCE}"
    )
    add_custom_target(${TARGET} DEPENDS ${GENERATED_HEADER})
endfunction()

add_executable(ircsrv ${ircsrv_SOURCES})
add_flatbuffer(ircsrv_flatbuffers flatbuffers/greeter.fbs)
add_dependencies(ircsrv ${ircsrv_DEPENDENCIES} ircsrv_flatbuffers)
target_link_libraries(ircsrv ${ircsrv_LIBRARIES})
