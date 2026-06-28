cmake_minimum_required(VERSION 3.20)

project(cpp_project LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(TEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tests")

add_executable(${PROJECT_NAME}
    "${SRC_DIR}/main.cpp"
)

target_include_directories(${PROJECT_NAME}
    PRIVATE
        "${INCLUDE_DIR}"
)

include(CTest)

if(BUILD_TESTING)
    add_executable(${PROJECT_NAME}_tests
        "${TEST_DIR}/test_main.cpp"
    )

    target_include_directories(${PROJECT_NAME}_tests
        PRIVATE
            "${INCLUDE_DIR}"
    )

    add_test(NAME ${PROJECT_NAME}_tests COMMAND ${PROJECT_NAME}_tests)
endif()
