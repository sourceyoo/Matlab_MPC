# Binary representation of a high-definition map.
std_msgs/Header header

# Binary data of the serialized map (format dependent, e.g. Lanelet2)
uint8[] map_format
uint8[] map_data

