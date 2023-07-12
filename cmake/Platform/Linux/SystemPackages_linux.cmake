#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

find_package(PkgConfig REQUIRED)
include(cmake/Install.cmake)
include(cmake/LYWrappers.cmake)

function(system_package_pkg_config package target alias)
pkg_check_modules(${alias} IMPORTED_TARGET ${package})
if (NOT TARGET PkgConfig::${alias})
    message(FATAL_ERROR "Package ${package} not found.")
else()
    add_library(3rdParty::${alias} ALIAS PkgConfig::${target})
    set_target_properties(PkgConfig::${target} PROPERTIES LY_SYSTEM_LIBRARY TRUE)

    cmake_path(RELATIVE_PATH CMAKE_CURRENT_LIST_DIR BASE_DIRECTORY ${LY_ROOT_FOLDER} OUTPUT_VARIABLE ${alias}_linux_cmake_rel_directory)
    ly_install(FILES "${CMAKE_CURRENT_LIST_FILE}"
        DESTINATION "${${alias}_linux_cmake_rel_directory}"
        COMPONENT ${CMAKE_INSTALL_DEFAULT_COMPONENT_NAME}
    )

endif()
endfunction()

function(system_package_find_package package target alias)
find_package(${package} REQUIRED)
if (NOT ${package}_FOUND)
    message(FATAL_ERROR "Package ${package} not found.")
else()
    add_library(3rdParty::${alias} ALIAS ${target})
    set_target_properties(${target} PROPERTIES LY_SYSTEM_LIBRARY TRUE)

    cmake_path(RELATIVE_PATH CMAKE_CURRENT_LIST_DIR BASE_DIRECTORY ${LY_ROOT_FOLDER} OUTPUT_VARIABLE ${alias}_linux_cmake_rel_directory)
    ly_install(FILES "${CMAKE_CURRENT_LIST_FILE}"
        DESTINATION "${${alias}_linux_cmake_rel_directory}"
        COMPONENT ${CMAKE_INSTALL_DEFAULT_COMPONENT_NAME}
    )

endif()
endfunction()

system_package_find_package(ZLIB ZLIB::ZLIB ZLIB)
add_library(3rdParty::zlib ALIAS ZLIB::ZLIB)

system_package_pkg_config(libunwind unwind unwind)

system_package_find_package(expat expat::expat expat)

system_package_find_package(Freetype Freetype::Freetype Freetype)

system_package_pkg_config(samplerate libsamplerate libsamplerate)

system_package_find_package(PNG PNG::PNG PNG)

system_package_pkg_config(OpenEXR OpenEXR OpenEXR)

system_package_find_package(SQLite3 SQLite::SQLite3 SQLite)

find_library(libmikktspace libmikktspace.so)
add_library(mikktspace SHARED IMPORTED)
set_property(TARGET mikktspace PROPERTY IMPORTED_LOCATION ${libmikktspace})
add_library(3rdParty::mikkelsen ALIAS mikktspace)

find_package(OpenSSL)
if (NOT OpenSSL_FOUND)
   message(FATAL_ERROR "Compiling on linux requires the development headers for OpenSSL.  Try using your package manager to install the OpenSSL development libraries following https://wiki.openssl.org/index.php/Libssl_API")
else()
    # OpenSSL targets should be considered as provided by the system
    set_target_properties(OpenSSL::SSL OpenSSL::Crypto PROPERTIES LY_SYSTEM_LIBRARY TRUE)

    # Alias the O3DE name to the official name
    add_library(3rdParty::OpenSSL ALIAS OpenSSL::SSL)
endif()

# include Install.cmake to get access to the ly_install function
include(cmake/Install.cmake)

# Copies over the OpenSSL_linux.cmake to the same location in the SDK layout.
cmake_path(RELATIVE_PATH CMAKE_CURRENT_LIST_DIR BASE_DIRECTORY ${LY_ROOT_FOLDER} OUTPUT_VARIABLE openssl_cmake_rel_directory)
ly_install(FILES "${CMAKE_CURRENT_LIST_FILE}"
    DESTINATION "${openssl_cmake_rel_directory}"
    COMPONENT ${CMAKE_INSTALL_DEFAULT_COMPONENT_NAME}
)

set(DXC_NAME "DirectXShaderCompilerDxc")
set(TARGET_WITH_NAMESPACE "3rdParty::${DXC_NAME}")
if (TARGET ${TARGET_WITH_NAMESPACE})
    return()
endif()

set(dxc_output_subfolder "Builders/DirectXShaderCompiler")
set(${DXC_NAME}_BINARY_DIR /bin)
set(${DXC_NAME}_LIB_DIR /usr/lib64)

add_library(${TARGET_WITH_NAMESPACE} INTERFACE IMPORTED GLOBAL)

set(${DXC_NAME}_BIN_RUNTIME_DEPENDENCIES ${${DXC_NAME}_BINARY_DIR}/dxc ${${DXC_NAME}_BINARY_DIR}/dxc-3.7)
ly_add_target_files(TARGETS ${TARGET_WITH_NAMESPACE} OUTPUT_SUBDIRECTORY "${dxc_output_subfolder}/bin" FILES ${${DXC_NAME}_BIN_RUNTIME_DEPENDENCIES})

set(${DXC_NAME}_LIB_RUNTIME_DEPENDENCIES ${${DXC_NAME}_LIB_DIR}/libdxcompiler.so ${${DXC_NAME}_LIB_DIR}/libdxcompiler.so.3.7)

ly_add_target_files(TARGETS ${TARGET_WITH_NAMESPACE} OUTPUT_SUBDIRECTORY "${dxc_output_subfolder}/lib" FILES ${${DXC_NAME}_LIB_RUNTIME_DEPENDENCIES})
set(${DXC_NAME}_FOUND True)
