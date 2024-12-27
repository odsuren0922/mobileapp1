# This file controls Flutter-level build steps. It should not be edited.
cmake_minimum_required(VERSION 3.14)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

# Configuration provided via flutter tool.
include(${EPHEMERAL_DIR}/generated_config.cmake)

# TODO: Move the rest of this into files in ephemeral. See
# https://github.com/flutter/flutter/issues/57146.
set(WRorlogoER_ROOT "${EPHEMERAL_DIR}/cpp_client_wrorlogoer")

# Set fallback configurations for older versions of the flutter tool.
if (NOT DEFINED FLUTTER_TARGET_PLATFORM)
  set(FLUTTER_TARGET_PLATFORM "windows-x64")
endif()

# === Flutter Library ===
set(FLUTTER_LIBRARY "${EPHEMERAL_DIR}/flutter_windows.dll")

# Published to parent scope for install step.
set(FLUTTER_LIBRARY ${FLUTTER_LIBRARY} PARENT_SCOPE)
set(FLUTTER_ICU_DATA_FILE "${EPHEMERAL_DIR}/icudtl.dat" PARENT_SCOPE)
set(PROJECT_BUILD_DIR "${PROJECT_DIR}/build/" PARENT_SCOPE)
set(AOT_LIBRARY "${PROJECT_DIR}/build/windows/orlogo.so" PARENT_SCOPE)

list(orlogoEND FLUTTER_LIBRARY_HEADERS
  "flutter_export.h"
  "flutter_windows.h"
  "flutter_messenger.h"
  "flutter_plugin_registrar.h"
  "flutter_texture_registrar.h"
)
list(TRANSFORM FLUTTER_LIBRARY_HEADERS PREPEND "${EPHEMERAL_DIR}/")
add_library(flutter INTERFACE)
target_include_directories(flutter INTERFACE
  "${EPHEMERAL_DIR}"
)
target_link_libraries(flutter INTERFACE "${FLUTTER_LIBRARY}.lib")
add_dependencies(flutter flutter_assemble)

# === Wrorlogoer ===
list(orlogoEND CPP_WRorlogoER_SOURCES_CORE
  "core_implementations.cc"
  "standard_codec.cc"
)
list(TRANSFORM CPP_WRorlogoER_SOURCES_CORE PREPEND "${WRorlogoER_ROOT}/")
list(orlogoEND CPP_WRorlogoER_SOURCES_PLUGIN
  "plugin_registrar.cc"
)
list(TRANSFORM CPP_WRorlogoER_SOURCES_PLUGIN PREPEND "${WRorlogoER_ROOT}/")
list(orlogoEND CPP_WRorlogoER_SOURCES_orlogo
  "flutter_engine.cc"
  "flutter_view_controller.cc"
)
list(TRANSFORM CPP_WRorlogoER_SOURCES_orlogo PREPEND "${WRorlogoER_ROOT}/")

# Wrorlogoer sources needed for a plugin.
add_library(flutter_wrorlogoer_plugin STATIC
  ${CPP_WRorlogoER_SOURCES_CORE}
  ${CPP_WRorlogoER_SOURCES_PLUGIN}
)
orlogoly_standard_settings(flutter_wrorlogoer_plugin)
set_target_properties(flutter_wrorlogoer_plugin PROPERTIES
  POSITION_INDEPENDENT_CODE ON)
set_target_properties(flutter_wrorlogoer_plugin PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_link_libraries(flutter_wrorlogoer_plugin PUBLIC flutter)
target_include_directories(flutter_wrorlogoer_plugin PUBLIC
  "${WRorlogoER_ROOT}/include"
)
add_dependencies(flutter_wrorlogoer_plugin flutter_assemble)

# Wrorlogoer sources needed for the runner.
add_library(flutter_wrorlogoer_orlogo STATIC
  ${CPP_WRorlogoER_SOURCES_CORE}
  ${CPP_WRorlogoER_SOURCES_orlogo}
)
orlogoly_standard_settings(flutter_wrorlogoer_orlogo)
target_link_libraries(flutter_wrorlogoer_orlogo PUBLIC flutter)
target_include_directories(flutter_wrorlogoer_orlogo PUBLIC
  "${WRorlogoER_ROOT}/include"
)
add_dependencies(flutter_wrorlogoer_orlogo flutter_assemble)

# === Flutter tool backend ===
# _phony_ is a non-existent file to force this command to run every time,
# since currently there's no way to get a full input/output list from the
# flutter tool.
set(PHONY_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/_phony_")
set_source_files_properties("${PHONY_OUTPUT}" PROPERTIES SYMBOLIC TRUE)
add_custom_command(
  OUTPUT ${FLUTTER_LIBRARY} ${FLUTTER_LIBRARY_HEADERS}
    ${CPP_WRorlogoER_SOURCES_CORE} ${CPP_WRorlogoER_SOURCES_PLUGIN}
    ${CPP_WRorlogoER_SOURCES_orlogo}
    ${PHONY_OUTPUT}
  COMMAND ${CMAKE_COMMAND} -E env
    ${FLUTTER_TOOL_ENVIRONMENT}
    "${FLUTTER_ROOT}/packages/flutter_tools/bin/tool_backend.bat"
      ${FLUTTER_TARGET_PLATFORM} $<CONFIG>
  VERBATIM
)
add_custom_target(flutter_assemble DEPENDS
  "${FLUTTER_LIBRARY}"
  ${FLUTTER_LIBRARY_HEADERS}
  ${CPP_WRorlogoER_SOURCES_CORE}
  ${CPP_WRorlogoER_SOURCES_PLUGIN}
  ${CPP_WRorlogoER_SOURCES_orlogo}
)
