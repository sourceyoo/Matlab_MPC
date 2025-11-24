# Global route information for the planner
# CAPACITY=100 (IDL 상한 정보는 .msg에서 표기 불가)
std_msgs/Header header
autoware_auto_planning_msgs/TrajectoryPoint start_point
autoware_auto_planning_msgs/TrajectoryPoint goal_point
autoware_auto_mapping_msgs/MapPrimitive[] primitives   # ← 의존 패키지 필요

