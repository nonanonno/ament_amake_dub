function(ament_dub_add_test package_name)
  cmake_parse_arguments(ARG "" "PACKAGE_DIR" "RUN_EXTRA" ${ARGN})
  if(NOT ARG_PACKAGE_DIR)
    set(ARG_PACKAGE_DIR "${CMAKE_CURRENT_LIST_DIR}/${package_name}")
  endif()
  if(NOT IS_ABSOLUTE "${ARG_PACKAGE_DIR}")
    set(ARG_PACKAGE_DIR "${CMAKE_CURRENT_LIST_DIR}/${ARG_PACKAGE_DIR}")
  endif()

  set(_cmd
    "dub"
    "test"
    "--root"
    "${ARG_PACKAGE_DIR}"
    "--"
    ${ARG_RUN_EXTRA})

  add_test(NAME "test_${package_name}"
    COMMAND ${_cmd})
endfunction()
