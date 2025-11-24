# All rights reserved.
cmake_minimum_required(VERSION 3.5)
project(autoware_auto_planning_msgs)

# Minimal CMake for MATLAB ros2genmsg shim (MSG-based)
find_package(ament_cmake REQUIRED)

# Messages referenced by our .msg files
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(builtin_interfaces REQUIRED)

# Optional/indirect deps (present in original package; keep QUIET)
find_package(autoware_auto_mapping_msgs QUIET)
find_package(nav_msgs QUIET)
find_package(action_msgs QUIET)
find_package(autoware_auto_geometry_msgs QUIET)

# No rosidl_generate_interfaces here — MATLAB ros2genmsg will generate code itself.
ament_package()

