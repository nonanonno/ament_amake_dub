cmake_minimum_required(VERSION 3.5)
project(test_pkg1)

find_package(ament_cmake REQUIRED)
find_package(ament_cmake_dub REQUIRED)

ament_dub_configure(${PROJECT_NAME})

ament_dub_add_library(${PROJECT_NAME}
  CONFIG lib
)

ament_dub_add_test(${PROJECT_NAME}
  RUN_EXTRA -i fail
)

install(
  DIRECTORY ${PROJECT_NAME}
  DESTINATION "lib/dub"
)

ament_package()
