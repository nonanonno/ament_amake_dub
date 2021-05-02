macro(_ament_cmake_dub_register_environment_hook package_name)
  if(NOT DEFINED _AMENT_CMAKE_DUB_ENVIRONMENT_HOOK_REGISTERED)
    set(_AMENT_CMAKE_DUB_ENVIRONMENT_HOOK_REGISTERED)

    if(NOT DEFINED DUB_INSTALL_DIR)
      set(DUB_INSTALL_DIR
        "lib/dub/${package_name}")
    endif()

    find_package(ament_cmake_core QUIET REQUIRED)

    set(AMENT_CMAKE_ENVIRONMENT_HOOKS_DESC_dub_package_path
      "prepend-non-duplicate;DUB_PACKAGE_PATH;${DUB_INSTALL_DIR}")
    ament_environment_hooks(
      "${ament_cmake_dub_DIR}/template/dub_package_path.sh.in")
  endif()
endmacro()

include("${ament_cmake_dub_DIR}/ament_dub_add.cmake")
include("${ament_cmake_dub_DIR}/ament_dub_configure.cmake")
include("${ament_cmake_dub_DIR}/ament_dub_add_test.cmake")
