set(libressl_URL https://github.com/libressl-portable/portable)
set(libressl_TAG v2.6.4)

ExternalProject_Add(libressl
    PREFIX libressl
    GIT_REPOSITORY ${libressl_URL}
    GIT_TAG ${libressl_TAG}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
    CMAKE_CACHE_ARGS
        -DLIBRESSL_SKIP_INSTALL:BOOL=ON
)

ExternalProject_Add_Step(libressl autogen
    COMMAND cd ${CMAKE_BINARY_DIR}/libressl/src/libressl && ./autogen.sh
    DEPENDEES patch
    DEPENDERS configure 
)

set(paho_URL https://github.com/eclipse/paho.mqtt.c.git)
set(paho_TAG 6aa07f5)

ExternalProject_Add(paho
    PREFIX paho
    DEPENDS libressl
    GIT_REPOSITORY ${paho_URL}
    GIT_TAG ${paho_TAG}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
    CMAKE_CACHE_ARGS
        -DPAHO_WITH_SSL:BOOL=ON
	-DPAHO_BUILD_STATIC:BOOL=ON
	-DOPENSSL_SEARCH_PATH:STRING=${CMAKE_BINARY_DIR}/libressl/src/libressl
	-DOPENSSL_LIB:STRING=${CMAKE_BINARY_DIR}/libressl/src/libressl/ssl
	-DOPENSSLCRYPTO_LIB:STRING=${CMAKE_BINARY_DIR}/libressl/src/libressl/crypto
	-DOPENSSL_LIB:STRING=${CMAKE_BINARY_DIR}/libressl/src/libressl/ssl/libssl.so
	-DOPENSSLCRYPTO_LIB:STRING=${CMAKE_BINARY_DIR}/libressl/src/libressl/crypto/libcrypto.so
	-DOPENSSL_INC_SEARCH_PATH:STRING=${CMAKE_BINARY_DIR}/libressl/src/libressl/include
	-DOPENSSL_LIB_SEARCH_PATH:STRING=${CMAKE_BINARY_DIR}/libressl/src/libressl
)
