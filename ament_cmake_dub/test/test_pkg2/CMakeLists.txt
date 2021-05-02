cmake_minimum_required(VERSION 3.5)
project(test_pkg2)

find_package(ament_cmake REQUIRED)
find_package(ament_cmake_dub REQUIRED)

ament_dub_configure(${PROJECT_NAME})

ament_dub_add_executable(${PROJECT_NAME}
  CONFIG exec1
  OUTPUT bin/executable1
)

ament_dub_add_executable(${PROJECT_NAME}
  CONFIG exec2
  OUTPUT bin/executable2
)

install(
  DIRECTORY ${PROJECT_NAME}
  DESTINATION "lib/dub"
)

ament_package()
