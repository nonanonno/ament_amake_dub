macro(ament_dub_configure)
  _ament_cmake_dub_register_environment_hook(${ARGN})
  _ament_cmake_dub_configure(${ARGN})
endmacro()

function(_ament_cmake_dub_configure package_name)
  cmake_parse_arguments(ARG "" "PACKAGE_DIR;PACKAGE_XML_DIRECTORY" "" ${ARGN})
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

  if(NOT EXISTS "${ARG_PACKAGE_DIR}/dub.json")
    message(FATAL_ERROR "ament_dub_configure() the DUB package "
    "folder '${ARG_PACKAGE_DIR}' doesn't contain an 'dub.json' file")
  endif()

  if(NOT ARG_PACKAGE_XML_DIRECTORY)
    set(ARG_PACKAGE_XML_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}")
  endif()


  stamp(${ARG_PACKAGE_XML_DIRECTORY}/package.xml)
  stamp(${ARG_PACKAGE_DIR}/dub.json)

  set(_cmd
    "${ament_cmake_dub_DIR}/make_local_package"
    "${ARG_PACKAGE_XML_DIRECTORY}/package.xml"
    "${ARG_PACKAGE_DIR}"
  )
  execute_process(
    COMMAND ${_cmd}
    RESULT_VARIABLE _res
  )
  if(NOT _res EQUAL 0)
    string(REPLACE ";" " " _cmd_str "${_cmd}")
    message(FATAL_ERROR
      "execute_process(${_cmd_str}) returned error code ${_res}")
  endif()
endfunction()
