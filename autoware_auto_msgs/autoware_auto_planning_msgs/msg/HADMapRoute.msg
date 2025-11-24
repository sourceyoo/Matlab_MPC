# A route within a high-definition map defined by the start and goal points and map primitives describing the route between the two.
std_msgs/Header header
# The start_pose must exist within the bounds of the primitives in the first segment.
geometry_msgs/Pose start_pose
# The goal_pose must exist within the bounds of the primitives in the last segment.
geometry_msgs/Pose goal_pose
autoware_auto_mapping_msgs/HADMapSegment[] segments    # ← 의존 패키지 필요

