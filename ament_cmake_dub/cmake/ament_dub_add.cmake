macro(ament_dub_add_executable)
  _ament_cmake_dub_build(${ARGN})
endmacro()

macro(ament_dub_add_library package_name)
  cmake_parse_arguments(ARG "" "OUTPUT" "" ${ARGN})
  if(ARG_OUTPUT)
    _ament_cmake_dub_build(${package_name} ${ARGN} SKIP_INSTALL)
  else()
    _ament_cmake_dub_build(${package_name} ${ARGN} SKIP_INSTALL
      OUTPUT "lib${package_name}.a"
    )
  endif()
endmacro()

macro(_ament_cmake_dub_parse_args pacakge_name)
  cmake_parse_arguments(ARG "SKIP_INSTALL" "PACKAGE_DIR;VERSION;CONFIG;OUTPUT" "" ${ARGN})
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "ament_dub_build_package() called with unused "
      "arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT ARG_PACKAGE_DIR)
    set(ARG_PACKAGE_DIR "${CMAKE_CURRENT_LIST_DIR}/${package_name}")
  endif()
  if(NOT IS_ABSOLUTE "${ARG_PACKAGE_DIR}")
    set(ARG_PACKAGE_DIR "${CMAKE_CURRENT_LIST_DIR}/${ARG_PACKAGE_DIR}")
  endif()

  if(NOT ARG_VERSION)
    # Use package.xml version
    if(NOT _AMNT_PACKAGE_NAME)
      ament_package_xml()
    endif()
    set(ARG_VERSION "${${PROJECT_NAME}_VERSION}")
  endif()

  if(NOT EXISTS "${ARG_PACKAGE_DIR}/dub.json")
    message(FATAL_ERROR "ament_dub_build_pacakge() the DUB package "
    "folder '${ARG_PACKAGE_DIR}' doesn't contain an 'dub.json' file")
  endif()

  if(NOT ARG_OUTPUT)
    set(ARG_OUTPUT "${package_name}")
  endif()

endmacro()

function(_ament_cmake_dub_build package_name)
  _ament_cmake_dub_parse_args(${package_name} ${ARGN})

  if(ARG_CONFIG)
    set(config_name "${pacakge_name}_${ARG_CONFIG}")
    set(dub_extra "-c" "${ARG_CONFIG}")
  else()
    set(config_name "${package_name}")
  endif()

  add_custom_target(${config_name} ALL
    COMMAND dub build --root ${ARG_PACKAGE_DIR} ${dub_extra}
    BYPRODUCTS ${ARG_PACKAGE_DIR}/${ARG_OUTPUT}
  )
  get_filename_component(destination "${ARG_OUTPUT}" DIRECTORY)
  if(NOT ARG_SKIP_INSTALL)
    install(
      PROGRAMS ${ARG_PACKAGE_DIR}/${ARG_OUTPUT}
      DESTINATION lib/${package_name}/${destination}
    )
  endif()

endfunction()
