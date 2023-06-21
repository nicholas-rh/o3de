#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

include_guard()

find_package(PkgConfig REQUIRED)

function(system_package_pkg_config package target alias)
pkg_check_modules(${alias} IMPORTED_TARGET ${package})
if (NOT TARGET PkgConfig::${alias})
    message(FATAL_ERROR "Package ${package} not found.")
else()
    add_library(3rdParty::${alias} ALIAS PkgConfig::${target})
    set_target_properties(PkgConfig::${target} PROPERTIES LY_SYSTEM_LIBRARY TRUE)

    # include Install.cmake to get access to the ly_install function
    include(cmake/Install.cmake)

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

    # include Install.cmake to get access to the ly_install function
    include(cmake/Install.cmake)

    cmake_path(RELATIVE_PATH CMAKE_CURRENT_LIST_DIR BASE_DIRECTORY ${LY_ROOT_FOLDER} OUTPUT_VARIABLE ${alias}_linux_cmake_rel_directory)
    ly_install(FILES "${CMAKE_CURRENT_LIST_FILE}"
        DESTINATION "${${alias}_linux_cmake_rel_directory}"
        COMPONENT ${CMAKE_INSTALL_DEFAULT_COMPONENT_NAME}
    )

endif()
endfunction()
