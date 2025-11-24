// generated from rosidl_generator_c/resource/idl__description.c.em
// with input from autoware_auto_planning_msgs:msg/TrajectoryPoint.idl
// generated code does not contain a copyright notice

#include "autoware_auto_planning_msgs/msg/detail/trajectory_point__functions.h"

ROSIDL_GENERATOR_C_PUBLIC_autoware_auto_planning_msgs
const rosidl_type_hash_t *
autoware_auto_planning_msgs__msg__TrajectoryPoint__get_type_hash(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static rosidl_type_hash_t hash = {1, {
      0x93, 0xbd, 0x64, 0xe8, 0x10, 0xb7, 0xf6, 0x4d,
      0x47, 0xed, 0x78, 0x46, 0x60, 0x58, 0x90, 0xb1,
      0x13, 0x26, 0xaa, 0x7f, 0x59, 0xea, 0xd1, 0x68,
      0x2f, 0x66, 0x67, 0x55, 0x6f, 0x5d, 0xd9, 0x02,
    }};
  return &hash;
}

#include <assert.h>
#include <string.h>

// Include directives for referenced types
#include "geometry_msgs/msg/detail/quaternion__functions.h"
#include "builtin_interfaces/msg/detail/duration__functions.h"
#include "geometry_msgs/msg/detail/pose__functions.h"
#include "geometry_msgs/msg/detail/point__functions.h"

// Hashes for external referenced types
#ifndef NDEBUG
static const rosidl_type_hash_t builtin_interfaces__msg__Duration__EXPECTED_HASH = {1, {
    0xe8, 0xd0, 0x09, 0xf6, 0x59, 0x81, 0x6f, 0x75,
    0x8b, 0x75, 0x33, 0x4e, 0xe1, 0xa9, 0xca, 0x5b,
    0x5c, 0x0b, 0x85, 0x98, 0x43, 0x26, 0x1f, 0x14,
    0xc7, 0xf9, 0x37, 0x34, 0x95, 0x99, 0xd9, 0x3b,
  }};
static const rosidl_type_hash_t geometry_msgs__msg__Point__EXPECTED_HASH = {1, {
    0x69, 0x63, 0x08, 0x48, 0x42, 0xa9, 0xb0, 0x44,
    0x94, 0xd6, 0xb2, 0x94, 0x1d, 0x11, 0x44, 0x47,
    0x08, 0xd8, 0x92, 0xda, 0x2f, 0x4b, 0x09, 0x84,
    0x3b, 0x9c, 0x43, 0xf4, 0x2a, 0x7f, 0x68, 0x81,
  }};
static const rosidl_type_hash_t geometry_msgs__msg__Pose__EXPECTED_HASH = {1, {
    0xd5, 0x01, 0x95, 0x4e, 0x94, 0x76, 0xce, 0xa2,
    0x99, 0x69, 0x84, 0xe8, 0x12, 0x05, 0x4b, 0x68,
    0x02, 0x6a, 0xe0, 0xbf, 0xae, 0x78, 0x9d, 0x9a,
    0x10, 0xb2, 0x3d, 0xaf, 0x35, 0xcc, 0x90, 0xfa,
  }};
static const rosidl_type_hash_t geometry_msgs__msg__Quaternion__EXPECTED_HASH = {1, {
    0x8a, 0x76, 0x5f, 0x66, 0x77, 0x8c, 0x8f, 0xf7,
    0xc8, 0xab, 0x94, 0xaf, 0xcc, 0x59, 0x0a, 0x2e,
    0xd5, 0x32, 0x5a, 0x1d, 0x9a, 0x07, 0x6f, 0xff,
    0xf3, 0x8f, 0xbc, 0xe3, 0x6f, 0x45, 0x86, 0x84,
  }};
#endif

static char autoware_auto_planning_msgs__msg__TrajectoryPoint__TYPE_NAME[] = "autoware_auto_planning_msgs/msg/TrajectoryPoint";
static char builtin_interfaces__msg__Duration__TYPE_NAME[] = "builtin_interfaces/msg/Duration";
static char geometry_msgs__msg__Point__TYPE_NAME[] = "geometry_msgs/msg/Point";
static char geometry_msgs__msg__Pose__TYPE_NAME[] = "geometry_msgs/msg/Pose";
static char geometry_msgs__msg__Quaternion__TYPE_NAME[] = "geometry_msgs/msg/Quaternion";

// Define type names, field names, and default values
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__time_from_start[] = "time_from_start";
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__pose[] = "pose";
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__longitudinal_velocity_mps[] = "longitudinal_velocity_mps";
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__lateral_velocity_mps[] = "lateral_velocity_mps";
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__acceleration_mps2[] = "acceleration_mps2";
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__heading_rate_rps[] = "heading_rate_rps";
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__front_wheel_angle_rad[] = "front_wheel_angle_rad";
static char autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__rear_wheel_angle_rad[] = "rear_wheel_angle_rad";

static rosidl_runtime_c__type_description__Field autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELDS[] = {
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__time_from_start, 15, 15},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_NESTED_TYPE,
      0,
      0,
      {builtin_interfaces__msg__Duration__TYPE_NAME, 31, 31},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__pose, 4, 4},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_NESTED_TYPE,
      0,
      0,
      {geometry_msgs__msg__Pose__TYPE_NAME, 22, 22},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__longitudinal_velocity_mps, 25, 25},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_FLOAT,
      0,
      0,
      {NULL, 0, 0},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__lateral_velocity_mps, 20, 20},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_FLOAT,
      0,
      0,
      {NULL, 0, 0},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__acceleration_mps2, 17, 17},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_FLOAT,
      0,
      0,
      {NULL, 0, 0},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__heading_rate_rps, 16, 16},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_FLOAT,
      0,
      0,
      {NULL, 0, 0},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__front_wheel_angle_rad, 21, 21},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_FLOAT,
      0,
      0,
      {NULL, 0, 0},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELD_NAME__rear_wheel_angle_rad, 20, 20},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_FLOAT,
      0,
      0,
      {NULL, 0, 0},
    },
    {NULL, 0, 0},
  },
};

static rosidl_runtime_c__type_description__IndividualTypeDescription autoware_auto_planning_msgs__msg__TrajectoryPoint__REFERENCED_TYPE_DESCRIPTIONS[] = {
  {
    {builtin_interfaces__msg__Duration__TYPE_NAME, 31, 31},
    {NULL, 0, 0},
  },
  {
    {geometry_msgs__msg__Point__TYPE_NAME, 23, 23},
    {NULL, 0, 0},
  },
  {
    {geometry_msgs__msg__Pose__TYPE_NAME, 22, 22},
    {NULL, 0, 0},
  },
  {
    {geometry_msgs__msg__Quaternion__TYPE_NAME, 28, 28},
    {NULL, 0, 0},
  },
};

const rosidl_runtime_c__type_description__TypeDescription *
autoware_auto_planning_msgs__msg__TrajectoryPoint__get_type_description(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static bool constructed = false;
  static const rosidl_runtime_c__type_description__TypeDescription description = {
    {
      {autoware_auto_planning_msgs__msg__TrajectoryPoint__TYPE_NAME, 47, 47},
      {autoware_auto_planning_msgs__msg__TrajectoryPoint__FIELDS, 8, 8},
    },
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__REFERENCED_TYPE_DESCRIPTIONS, 4, 4},
  };
  if (!constructed) {
    assert(0 == memcmp(&builtin_interfaces__msg__Duration__EXPECTED_HASH, builtin_interfaces__msg__Duration__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[0].fields = builtin_interfaces__msg__Duration__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&geometry_msgs__msg__Point__EXPECTED_HASH, geometry_msgs__msg__Point__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[1].fields = geometry_msgs__msg__Point__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&geometry_msgs__msg__Pose__EXPECTED_HASH, geometry_msgs__msg__Pose__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[2].fields = geometry_msgs__msg__Pose__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&geometry_msgs__msg__Quaternion__EXPECTED_HASH, geometry_msgs__msg__Quaternion__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[3].fields = geometry_msgs__msg__Quaternion__get_type_description(NULL)->type_description.fields;
    constructed = true;
  }
  return &description;
}

static char toplevel_type_raw_source[] =
  "# Representation of a trajectory point for the controller\n"
  "builtin_interfaces/Duration time_from_start\n"
  "geometry_msgs/Pose pose\n"
  "float32 longitudinal_velocity_mps\n"
  "float32 lateral_velocity_mps\n"
  "float32 acceleration_mps2\n"
  "float32 heading_rate_rps\n"
  "float32 front_wheel_angle_rad\n"
  "float32 rear_wheel_angle_rad\n"
  "";

static char msg_encoding[] = "msg";

// Define all individual source functions

const rosidl_runtime_c__type_description__TypeSource *
autoware_auto_planning_msgs__msg__TrajectoryPoint__get_individual_type_description_source(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static const rosidl_runtime_c__type_description__TypeSource source = {
    {autoware_auto_planning_msgs__msg__TrajectoryPoint__TYPE_NAME, 47, 47},
    {msg_encoding, 3, 3},
    {toplevel_type_raw_source, 300, 300},
  };
  return &source;
}

const rosidl_runtime_c__type_description__TypeSource__Sequence *
autoware_auto_planning_msgs__msg__TrajectoryPoint__get_type_description_sources(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static rosidl_runtime_c__type_description__TypeSource sources[5];
  static const rosidl_runtime_c__type_description__TypeSource__Sequence source_sequence = {sources, 5, 5};
  static bool constructed = false;
  if (!constructed) {
    sources[0] = *autoware_auto_planning_msgs__msg__TrajectoryPoint__get_individual_type_description_source(NULL),
    sources[1] = *builtin_interfaces__msg__Duration__get_individual_type_description_source(NULL);
    sources[2] = *geometry_msgs__msg__Point__get_individual_type_description_source(NULL);
    sources[3] = *geometry_msgs__msg__Pose__get_individual_type_description_source(NULL);
    sources[4] = *geometry_msgs__msg__Quaternion__get_individual_type_description_source(NULL);
    constructed = true;
  }
  return &source_sequence;
}
