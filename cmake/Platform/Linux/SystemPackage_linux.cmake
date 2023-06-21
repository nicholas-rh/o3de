#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

include_guard()

find_package(PkgConfig REQUIRED)

function(find_system_package package)
pkg_check_modules(${package}_target IMPORTED_TARGET ${package})
if (NOT TARGET PkgConfig::${package}_target)
    message(FATAL_ERROR "Package ${package} not found.")
else()
    add_library(3rdParty::${package}_target ALIAS PkgConfig::${package}_target)
    set_target_properties(PkgConfig::${package}_target
        PROPERTIES 
            LY_SYSTEM_LIBRARY TRUE)

    # include Install.cmake to get access to the ly_install function
    include(cmake/Install.cmake)

    cmake_path(RELATIVE_PATH CMAKE_CURRENT_LIST_DIR BASE_DIRECTORY ${LY_ROOT_FOLDER} OUTPUT_VARIABLE ${package}_linux_cmake_rel_directory)
    ly_install(FILES "${CMAKE_CURRENT_LIST_FILE}"
        DESTINATION "${${package}_linux_cmake_rel_directory}"
        COMPONENT ${CMAKE_INSTALL_DEFAULT_COMPONENT_NAME}
    )

endif()
endfunction()
