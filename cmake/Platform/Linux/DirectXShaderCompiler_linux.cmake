#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
# 
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

# This is modified to target Fedora-specific directories and may not work on other OS

include(cmake/LYWrappers.cmake)

set(MY_NAME "DirectXShaderCompilerDxc")
set(TARGET_WITH_NAMESPACE "3rdParty::${MY_NAME}")
if (TARGET ${TARGET_WITH_NAMESPACE})
    return()
endif()

set(output_subfolder "Builders/DirectXShaderCompiler")
set(${MY_NAME}_BINARY_DIR /bin)
set(${MY_NAME}_LIB_DIR /usr/lib64)

add_library(${TARGET_WITH_NAMESPACE} INTERFACE IMPORTED GLOBAL)

set(${MY_NAME}_BIN_RUNTIME_DEPENDENCIES
        ${${MY_NAME}_BINARY_DIR}/dxc
        ${${MY_NAME}_BINARY_DIR}/dxc-3.7
        )
ly_add_target_files(TARGETS ${TARGET_WITH_NAMESPACE} OUTPUT_SUBDIRECTORY "${output_subfolder}/bin" FILES ${${MY_NAME}_BIN_RUNTIME_DEPENDENCIES})

set(${MY_NAME}_LIB_RUNTIME_DEPENDENCIES
        ${${MY_NAME}_LIB_DIR}/libdxcompiler.so
        ${${MY_NAME}_LIB_DIR}/libdxcompiler.so.3.7
        )
ly_add_target_files(TARGETS ${TARGET_WITH_NAMESPACE} OUTPUT_SUBDIRECTORY "${output_subfolder}/lib" FILES ${${MY_NAME}_LIB_RUNTIME_DEPENDENCIES})

set(${MY_NAME}_FOUND True)
