// generated from rosidl_generator_c/resource/idl__description.c.em
// with input from autoware_auto_planning_msgs:msg/PathPointWithLaneId.idl
// generated code does not contain a copyright notice

#include "autoware_auto_planning_msgs/msg/detail/path_point_with_lane_id__functions.h"

ROSIDL_GENERATOR_C_PUBLIC_autoware_auto_planning_msgs
const rosidl_type_hash_t *
autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_type_hash(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static rosidl_type_hash_t hash = {1, {
      0xff, 0x39, 0xbe, 0x66, 0x66, 0xb8, 0x6c, 0x9d,
      0xb8, 0x88, 0x03, 0xd3, 0xe7, 0x2d, 0xeb, 0x67,
      0x54, 0xc5, 0x18, 0x25, 0xb9, 0x1c, 0x96, 0x10,
      0x1f, 0x6d, 0x26, 0xa6, 0xe1, 0xe3, 0xa9, 0x3e,
    }};
  return &hash;
}

#include <assert.h>
#include <string.h>

// Include directives for referenced types
#include "geometry_msgs/msg/detail/quaternion__functions.h"
#include "autoware_auto_planning_msgs/msg/detail/path_point__functions.h"
#include "geometry_msgs/msg/detail/pose__functions.h"
#include "geometry_msgs/msg/detail/point__functions.h"

// Hashes for external referenced types
#ifndef NDEBUG
static const rosidl_type_hash_t autoware_auto_planning_msgs__msg__PathPoint__EXPECTED_HASH = {1, {
    0x3d, 0x68, 0x60, 0xf5, 0x94, 0x45, 0x95, 0x26,
    0xe0, 0xa7, 0x9c, 0xba, 0x6f, 0x27, 0xb5, 0xb9,
    0xad, 0x26, 0x59, 0x47, 0xcc, 0x59, 0x49, 0xa1,
    0x28, 0x67, 0xbe, 0x14, 0xd6, 0xa1, 0x19, 0xdc,
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

static char autoware_auto_planning_msgs__msg__PathPointWithLaneId__TYPE_NAME[] = "autoware_auto_planning_msgs/msg/PathPointWithLaneId";
static char autoware_auto_planning_msgs__msg__PathPoint__TYPE_NAME[] = "autoware_auto_planning_msgs/msg/PathPoint";
static char geometry_msgs__msg__Point__TYPE_NAME[] = "geometry_msgs/msg/Point";
static char geometry_msgs__msg__Pose__TYPE_NAME[] = "geometry_msgs/msg/Pose";
static char geometry_msgs__msg__Quaternion__TYPE_NAME[] = "geometry_msgs/msg/Quaternion";

// Define type names, field names, and default values
static char autoware_auto_planning_msgs__msg__PathPointWithLaneId__FIELD_NAME__point[] = "point";
static char autoware_auto_planning_msgs__msg__PathPointWithLaneId__FIELD_NAME__lane_ids[] = "lane_ids";

static rosidl_runtime_c__type_description__Field autoware_auto_planning_msgs__msg__PathPointWithLaneId__FIELDS[] = {
  {
    {autoware_auto_planning_msgs__msg__PathPointWithLaneId__FIELD_NAME__point, 5, 5},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_NESTED_TYPE,
      0,
      0,
      {autoware_auto_planning_msgs__msg__PathPoint__TYPE_NAME, 41, 41},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__PathPointWithLaneId__FIELD_NAME__lane_ids, 8, 8},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_INT64_UNBOUNDED_SEQUENCE,
      0,
      0,
      {NULL, 0, 0},
    },
    {NULL, 0, 0},
  },
};

static rosidl_runtime_c__type_description__IndividualTypeDescription autoware_auto_planning_msgs__msg__PathPointWithLaneId__REFERENCED_TYPE_DESCRIPTIONS[] = {
  {
    {autoware_auto_planning_msgs__msg__PathPoint__TYPE_NAME, 41, 41},
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
autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_type_description(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static bool constructed = false;
  static const rosidl_runtime_c__type_description__TypeDescription description = {
    {
      {autoware_auto_planning_msgs__msg__PathPointWithLaneId__TYPE_NAME, 51, 51},
      {autoware_auto_planning_msgs__msg__PathPointWithLaneId__FIELDS, 2, 2},
    },
    {autoware_auto_planning_msgs__msg__PathPointWithLaneId__REFERENCED_TYPE_DESCRIPTIONS, 4, 4},
  };
  if (!constructed) {
    assert(0 == memcmp(&autoware_auto_planning_msgs__msg__PathPoint__EXPECTED_HASH, autoware_auto_planning_msgs__msg__PathPoint__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[0].fields = autoware_auto_planning_msgs__msg__PathPoint__get_type_description(NULL)->type_description.fields;
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
  "# Contains a PathPoint and lanelet lane_id information.\n"
  "autoware_auto_planning_msgs/PathPoint point\n"
  "# Lanelet lane_id information.\n"
  "int64[] lane_ids\n"
  "";

static char msg_encoding[] = "msg";

// Define all individual source functions

const rosidl_runtime_c__type_description__TypeSource *
autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_individual_type_description_source(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static const rosidl_runtime_c__type_description__TypeSource source = {
    {autoware_auto_planning_msgs__msg__PathPointWithLaneId__TYPE_NAME, 51, 51},
    {msg_encoding, 3, 3},
    {toplevel_type_raw_source, 149, 149},
  };
  return &source;
}

const rosidl_runtime_c__type_description__TypeSource__Sequence *
autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_type_description_sources(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static rosidl_runtime_c__type_description__TypeSource sources[5];
  static const rosidl_runtime_c__type_description__TypeSource__Sequence source_sequence = {sources, 5, 5};
  static bool constructed = false;
  if (!constructed) {
    sources[0] = *autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_individual_type_description_source(NULL),
    sources[1] = *autoware_auto_planning_msgs__msg__PathPoint__get_individual_type_description_source(NULL);
    sources[2] = *geometry_msgs__msg__Point__get_individual_type_description_source(NULL);
    sources[3] = *geometry_msgs__msg__Pose__get_individual_type_description_source(NULL);
    sources[4] = *geometry_msgs__msg__Quaternion__get_individual_type_description_source(NULL);
    constructed = true;
  }
  return &source_sequence;
}
