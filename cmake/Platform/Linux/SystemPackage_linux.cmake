#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

include_guard()

find_package(PkgConfig REQUIRED)

function(find_system_package package target)
pkg_check_modules(${target} IMPORTED_TARGET ${package})
if (NOT TARGET PkgConfig::${target})
    message(FATAL_ERROR "Package ${package} not found.")
else()
    add_library(3rdParty::${target} ALIAS PkgConfig::${target})
    set_target_properties(PkgConfig::${target} PROPERTIES LY_SYSTEM_LIBRARY TRUE)

    # include Install.cmake to get access to the ly_install function
    include(cmake/Install.cmake)

    cmake_path(RELATIVE_PATH CMAKE_CURRENT_LIST_DIR BASE_DIRECTORY ${LY_ROOT_FOLDER} OUTPUT_VARIABLE ${target}_linux_cmake_rel_directory)
    ly_install(FILES "${CMAKE_CURRENT_LIST_FILE}"
        DESTINATION "${${target}_linux_cmake_rel_directory}"
        COMPONENT ${CMAKE_INSTALL_DEFAULT_COMPONENT_NAME}
    )

endif()
endfunction()
