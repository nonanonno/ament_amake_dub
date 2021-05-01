cmake_minimum_required(VERSION 3.5)
project(test_pkg1)

find_package(ament_cmake REQUIRED)
find_package(ament_cmake_dub REQUIRED)

ament_dub_add_executable(${PROJECT_NAME}
  CONFIG exec1
  OUTPUT bin/executable1
)

ament_dub_add_executable(${PROJECT_NAME}
  CONFIG exec2
  OUTPUT bin/executable2
)

ament_dub_add_library(${PROJECT_NAME}
  CONFIG test_pkg1
)

ament_package()
