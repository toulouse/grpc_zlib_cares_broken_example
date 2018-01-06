set(flatbuffers_URL https://github.com/google/flatbuffers)
set(flatbuffers_TAG master)

ExternalProject_Add(flatbuffers
    PREFIX flatbuffers
    GIT_REPOSITORY ${flatbuffers_URL}
    GIT_TAG ${flatbuffers_TAG}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DFLATBUFFERS_BUILD_TESTS:BOOL=OFF
        -DFLATBUFFERS_BUILD_FLATC:BOOL=ON
)

set(flatbuffers_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/flatbuffers/src/flatbuffers/include)
set(flatbuffers_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/flatbuffers/src/flatbuffers/libflatbuffers.a)
set(flatbuffers_GENERATOR ${CMAKE_CURRENT_BINARY_DIR}/flatbuffers/src/flatbuffers/flatc)
