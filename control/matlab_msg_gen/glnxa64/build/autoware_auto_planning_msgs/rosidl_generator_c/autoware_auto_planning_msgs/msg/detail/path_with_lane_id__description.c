// generated from rosidl_generator_c/resource/idl__description.c.em
// with input from autoware_auto_planning_msgs:msg/PathWithLaneId.idl
// generated code does not contain a copyright notice

#include "autoware_auto_planning_msgs/msg/detail/path_with_lane_id__functions.h"

ROSIDL_GENERATOR_C_PUBLIC_autoware_auto_planning_msgs
const rosidl_type_hash_t *
autoware_auto_planning_msgs__msg__PathWithLaneId__get_type_hash(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static rosidl_type_hash_t hash = {1, {
      0xa8, 0xb1, 0xed, 0xac, 0x21, 0x2b, 0x88, 0x1f,
      0x65, 0x06, 0x18, 0x88, 0x59, 0x5f, 0x2d, 0x89,
      0x8d, 0x46, 0xd0, 0x31, 0x8b, 0xc5, 0xf6, 0x4b,
      0x26, 0x7c, 0x8b, 0x6e, 0xfa, 0x80, 0x8a, 0x98,
    }};
  return &hash;
}

#include <assert.h>
#include <string.h>

// Include directives for referenced types
#include "geometry_msgs/msg/detail/quaternion__functions.h"
#include "std_msgs/msg/detail/header__functions.h"
#include "autoware_auto_planning_msgs/msg/detail/path_point__functions.h"
#include "geometry_msgs/msg/detail/point__functions.h"
#include "geometry_msgs/msg/detail/pose__functions.h"
#include "builtin_interfaces/msg/detail/time__functions.h"
#include "autoware_auto_planning_msgs/msg/detail/path_point_with_lane_id__functions.h"

// Hashes for external referenced types
#ifndef NDEBUG
static const rosidl_type_hash_t autoware_auto_planning_msgs__msg__PathPoint__EXPECTED_HASH = {1, {
    0x3d, 0x68, 0x60, 0xf5, 0x94, 0x45, 0x95, 0x26,
    0xe0, 0xa7, 0x9c, 0xba, 0x6f, 0x27, 0xb5, 0xb9,
    0xad, 0x26, 0x59, 0x47, 0xcc, 0x59, 0x49, 0xa1,
    0x28, 0x67, 0xbe, 0x14, 0xd6, 0xa1, 0x19, 0xdc,
  }};
static const rosidl_type_hash_t autoware_auto_planning_msgs__msg__PathPointWithLaneId__EXPECTED_HASH = {1, {
    0xff, 0x39, 0xbe, 0x66, 0x66, 0xb8, 0x6c, 0x9d,
    0xb8, 0x88, 0x03, 0xd3, 0xe7, 0x2d, 0xeb, 0x67,
    0x54, 0xc5, 0x18, 0x25, 0xb9, 0x1c, 0x96, 0x10,
    0x1f, 0x6d, 0x26, 0xa6, 0xe1, 0xe3, 0xa9, 0x3e,
  }};
static const rosidl_type_hash_t builtin_interfaces__msg__Time__EXPECTED_HASH = {1, {
    0xb1, 0x06, 0x23, 0x5e, 0x25, 0xa4, 0xc5, 0xed,
    0x35, 0x09, 0x8a, 0xa0, 0xa6, 0x1a, 0x3e, 0xe9,
    0xc9, 0xb1, 0x8d, 0x19, 0x7f, 0x39, 0x8b, 0x0e,
    0x42, 0x06, 0xce, 0xa9, 0xac, 0xf9, 0xc1, 0x97,
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
static const rosidl_type_hash_t std_msgs__msg__Header__EXPECTED_HASH = {1, {
    0xf4, 0x9f, 0xb3, 0xae, 0x2c, 0xf0, 0x70, 0xf7,
    0x93, 0x64, 0x5f, 0xf7, 0x49, 0x68, 0x3a, 0xc6,
    0xb0, 0x62, 0x03, 0xe4, 0x1c, 0x89, 0x1e, 0x17,
    0x70, 0x1b, 0x1c, 0xb5, 0x97, 0xce, 0x6a, 0x01,
  }};
#endif

static char autoware_auto_planning_msgs__msg__PathWithLaneId__TYPE_NAME[] = "autoware_auto_planning_msgs/msg/PathWithLaneId";
static char autoware_auto_planning_msgs__msg__PathPoint__TYPE_NAME[] = "autoware_auto_planning_msgs/msg/PathPoint";
static char autoware_auto_planning_msgs__msg__PathPointWithLaneId__TYPE_NAME[] = "autoware_auto_planning_msgs/msg/PathPointWithLaneId";
static char builtin_interfaces__msg__Time__TYPE_NAME[] = "builtin_interfaces/msg/Time";
static char geometry_msgs__msg__Point__TYPE_NAME[] = "geometry_msgs/msg/Point";
static char geometry_msgs__msg__Pose__TYPE_NAME[] = "geometry_msgs/msg/Pose";
static char geometry_msgs__msg__Quaternion__TYPE_NAME[] = "geometry_msgs/msg/Quaternion";
static char std_msgs__msg__Header__TYPE_NAME[] = "std_msgs/msg/Header";

// Define type names, field names, and default values
static char autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__header[] = "header";
static char autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__points[] = "points";
static char autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__left_bound[] = "left_bound";
static char autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__right_bound[] = "right_bound";

static rosidl_runtime_c__type_description__Field autoware_auto_planning_msgs__msg__PathWithLaneId__FIELDS[] = {
  {
    {autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__header, 6, 6},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_NESTED_TYPE,
      0,
      0,
      {std_msgs__msg__Header__TYPE_NAME, 19, 19},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__points, 6, 6},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_NESTED_TYPE_UNBOUNDED_SEQUENCE,
      0,
      0,
      {autoware_auto_planning_msgs__msg__PathPointWithLaneId__TYPE_NAME, 51, 51},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__left_bound, 10, 10},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_NESTED_TYPE_UNBOUNDED_SEQUENCE,
      0,
      0,
      {geometry_msgs__msg__Point__TYPE_NAME, 23, 23},
    },
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__PathWithLaneId__FIELD_NAME__right_bound, 11, 11},
    {
      rosidl_runtime_c__type_description__FieldType__FIELD_TYPE_NESTED_TYPE_UNBOUNDED_SEQUENCE,
      0,
      0,
      {geometry_msgs__msg__Point__TYPE_NAME, 23, 23},
    },
    {NULL, 0, 0},
  },
};

static rosidl_runtime_c__type_description__IndividualTypeDescription autoware_auto_planning_msgs__msg__PathWithLaneId__REFERENCED_TYPE_DESCRIPTIONS[] = {
  {
    {autoware_auto_planning_msgs__msg__PathPoint__TYPE_NAME, 41, 41},
    {NULL, 0, 0},
  },
  {
    {autoware_auto_planning_msgs__msg__PathPointWithLaneId__TYPE_NAME, 51, 51},
    {NULL, 0, 0},
  },
  {
    {builtin_interfaces__msg__Time__TYPE_NAME, 27, 27},
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
  {
    {std_msgs__msg__Header__TYPE_NAME, 19, 19},
    {NULL, 0, 0},
  },
};

const rosidl_runtime_c__type_description__TypeDescription *
autoware_auto_planning_msgs__msg__PathWithLaneId__get_type_description(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static bool constructed = false;
  static const rosidl_runtime_c__type_description__TypeDescription description = {
    {
      {autoware_auto_planning_msgs__msg__PathWithLaneId__TYPE_NAME, 46, 46},
      {autoware_auto_planning_msgs__msg__PathWithLaneId__FIELDS, 4, 4},
    },
    {autoware_auto_planning_msgs__msg__PathWithLaneId__REFERENCED_TYPE_DESCRIPTIONS, 7, 7},
  };
  if (!constructed) {
    assert(0 == memcmp(&autoware_auto_planning_msgs__msg__PathPoint__EXPECTED_HASH, autoware_auto_planning_msgs__msg__PathPoint__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[0].fields = autoware_auto_planning_msgs__msg__PathPoint__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&autoware_auto_planning_msgs__msg__PathPointWithLaneId__EXPECTED_HASH, autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[1].fields = autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&builtin_interfaces__msg__Time__EXPECTED_HASH, builtin_interfaces__msg__Time__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[2].fields = builtin_interfaces__msg__Time__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&geometry_msgs__msg__Point__EXPECTED_HASH, geometry_msgs__msg__Point__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[3].fields = geometry_msgs__msg__Point__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&geometry_msgs__msg__Pose__EXPECTED_HASH, geometry_msgs__msg__Pose__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[4].fields = geometry_msgs__msg__Pose__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&geometry_msgs__msg__Quaternion__EXPECTED_HASH, geometry_msgs__msg__Quaternion__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[5].fields = geometry_msgs__msg__Quaternion__get_type_description(NULL)->type_description.fields;
    assert(0 == memcmp(&std_msgs__msg__Header__EXPECTED_HASH, std_msgs__msg__Header__get_type_hash(NULL), sizeof(rosidl_type_hash_t)));
    description.referenced_type_descriptions.data[6].fields = std_msgs__msg__Header__get_type_description(NULL)->type_description.fields;
    constructed = true;
  }
  return &description;
}

static char toplevel_type_raw_source[] =
  "# Contains a PathPointWithLaneId path and left and right bound.\n"
  "std_msgs/Header header\n"
  "autoware_auto_planning_msgs/PathPointWithLaneId[] points\n"
  "geometry_msgs/Point[] left_bound\n"
  "geometry_msgs/Point[] right_bound\n"
  "";

static char msg_encoding[] = "msg";

// Define all individual source functions

const rosidl_runtime_c__type_description__TypeSource *
autoware_auto_planning_msgs__msg__PathWithLaneId__get_individual_type_description_source(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static const rosidl_runtime_c__type_description__TypeSource source = {
    {autoware_auto_planning_msgs__msg__PathWithLaneId__TYPE_NAME, 46, 46},
    {msg_encoding, 3, 3},
    {toplevel_type_raw_source, 212, 212},
  };
  return &source;
}

const rosidl_runtime_c__type_description__TypeSource__Sequence *
autoware_auto_planning_msgs__msg__PathWithLaneId__get_type_description_sources(
  const rosidl_message_type_support_t * type_support)
{
  (void)type_support;
  static rosidl_runtime_c__type_description__TypeSource sources[8];
  static const rosidl_runtime_c__type_description__TypeSource__Sequence source_sequence = {sources, 8, 8};
  static bool constructed = false;
  if (!constructed) {
    sources[0] = *autoware_auto_planning_msgs__msg__PathWithLaneId__get_individual_type_description_source(NULL),
    sources[1] = *autoware_auto_planning_msgs__msg__PathPoint__get_individual_type_description_source(NULL);
    sources[2] = *autoware_auto_planning_msgs__msg__PathPointWithLaneId__get_individual_type_description_source(NULL);
    sources[3] = *builtin_interfaces__msg__Time__get_individual_type_description_source(NULL);
    sources[4] = *geometry_msgs__msg__Point__get_individual_type_description_source(NULL);
    sources[5] = *geometry_msgs__msg__Pose__get_individual_type_description_source(NULL);
    sources[6] = *geometry_msgs__msg__Quaternion__get_individual_type_description_source(NULL);
    sources[7] = *std_msgs__msg__Header__get_individual_type_description_source(NULL);
    constructed = true;
  }
  return &source_sequence;
}
