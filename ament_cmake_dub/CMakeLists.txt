cmake_minimum_required(VERSION 3.5)
project(ament_cmake_dub NONE)

find_package(ament_cmake_core REQUIRED)

ament_package(
  CONFIG_EXTRAS "ament_cmake_dub-extras.cmake"
)

set(_cmd
  "dub"
  "build"
  "--single"
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/make_local_package.d"
  "&&"
  "mv"
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/make_local_package"
  "${CMAKE_CURRENT_BINARY_DIR}"
)

add_custom_target(make_local_package ALL
  COMMAND ${_cmd}
  BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/make_local_package"
)

install(
  PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/make_local_package"
  DESTINATION share/${PROJECT_NAME}/cmake
)

install(
  DIRECTORY cmake
  DESTINATION share/${PROJECT_NAME}
)
