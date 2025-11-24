# Represents a single map element like a lanelet, crosswalk, stop line, etc.
uint8 UNKNOWN=0
uint8 LANE=1
uint8 CROSSWALK=2
uint8 STOP_LINE=3
uint8 TRAFFIC_LIGHT=4
uint8 TRAFFIC_SIGN=5

# Unique ID for this map primitive
int64 id

# Type of primitive (use constants above)
uint8 type

