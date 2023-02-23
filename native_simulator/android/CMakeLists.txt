cmake_minimum_required(VERSION 3.21)  # for example

add_library(
        native_simulator
        SHARED

        # Provides a relative path to your source file(s).
        ../ios/Classes/native_simulator.cpp
)