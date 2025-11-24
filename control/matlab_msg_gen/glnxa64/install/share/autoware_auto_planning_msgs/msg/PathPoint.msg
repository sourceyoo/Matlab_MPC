# Represents a pose from a lanelet map, contains twist information.
geometry_msgs/Pose pose
float32 longitudinal_velocity_mps
float32 lateral_velocity_mps
float32 heading_rate_rps
# is_final: Denotes that the point is final, doesn't need further updates.
bool is_final

