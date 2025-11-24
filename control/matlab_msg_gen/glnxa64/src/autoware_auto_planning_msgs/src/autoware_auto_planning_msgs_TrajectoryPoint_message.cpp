// Copyright 2020-2022 The MathWorks, Inc.
// Common copy functions for autoware_auto_planning_msgs/TrajectoryPoint
#ifdef _MSC_VER
#pragma warning(push)
#pragma warning(disable : 4100)
#pragma warning(disable : 4265)
#pragma warning(disable : 4456)
#pragma warning(disable : 4458)
#pragma warning(disable : 4946)
#pragma warning(disable : 4244)
#else
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
#pragma GCC diagnostic ignored "-Wunused-local-typedefs"
#pragma GCC diagnostic ignored "-Wredundant-decls"
#pragma GCC diagnostic ignored "-Wnon-virtual-dtor"
#pragma GCC diagnostic ignored "-Wdelete-non-virtual-dtor"
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wshadow"
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#endif //_MSC_VER
#include "rclcpp/rclcpp.hpp"
#include "autoware_auto_planning_msgs/msg/trajectory_point.hpp"
#include "visibility_control.h"
#include "class_loader/multi_library_class_loader.hpp"
#include "ROS2PubSubTemplates.hpp"
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common : public MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::TrajectoryPoint> {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common(){}
    virtual void copy_from_struct(autoware_auto_planning_msgs::msg::TrajectoryPoint* msg, const matlab::data::Struct& arr, MultiLibLoader loader); 
    //----------------------------------------------------------------------------
    virtual MDArray_T get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::TrajectoryPoint* msg, MultiLibLoader loader, size_t size = 1);
};
  void ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common::copy_from_struct(autoware_auto_planning_msgs::msg::TrajectoryPoint* msg, const matlab::data::Struct& arr,
               MultiLibLoader loader) {
    try {
        //time_from_start
        const matlab::data::StructArray time_from_start_arr = arr["time_from_start"];
        auto msgClassPtr_time_from_start = getCommonObject<builtin_interfaces::msg::Duration>("ros2_builtin_interfaces_msg_Duration_common",loader);
        msgClassPtr_time_from_start->copy_from_struct(&msg->time_from_start,time_from_start_arr[0],loader);
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'time_from_start' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'time_from_start' is wrong type; expected a struct.");
    }
    try {
        //pose
        const matlab::data::StructArray pose_arr = arr["pose"];
        auto msgClassPtr_pose = getCommonObject<geometry_msgs::msg::Pose>("ros2_geometry_msgs_msg_Pose_common",loader);
        msgClassPtr_pose->copy_from_struct(&msg->pose,pose_arr[0],loader);
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'pose' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'pose' is wrong type; expected a struct.");
    }
    try {
        //longitudinal_velocity_mps
        const matlab::data::TypedArray<float> longitudinal_velocity_mps_arr = arr["longitudinal_velocity_mps"];
        msg->longitudinal_velocity_mps = longitudinal_velocity_mps_arr[0];
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'longitudinal_velocity_mps' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'longitudinal_velocity_mps' is wrong type; expected a single.");
    }
    try {
        //lateral_velocity_mps
        const matlab::data::TypedArray<float> lateral_velocity_mps_arr = arr["lateral_velocity_mps"];
        msg->lateral_velocity_mps = lateral_velocity_mps_arr[0];
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'lateral_velocity_mps' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'lateral_velocity_mps' is wrong type; expected a single.");
    }
    try {
        //acceleration_mps2
        const matlab::data::TypedArray<float> acceleration_mps2_arr = arr["acceleration_mps2"];
        msg->acceleration_mps2 = acceleration_mps2_arr[0];
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'acceleration_mps2' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'acceleration_mps2' is wrong type; expected a single.");
    }
    try {
        //heading_rate_rps
        const matlab::data::TypedArray<float> heading_rate_rps_arr = arr["heading_rate_rps"];
        msg->heading_rate_rps = heading_rate_rps_arr[0];
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'heading_rate_rps' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'heading_rate_rps' is wrong type; expected a single.");
    }
    try {
        //front_wheel_angle_rad
        const matlab::data::TypedArray<float> front_wheel_angle_rad_arr = arr["front_wheel_angle_rad"];
        msg->front_wheel_angle_rad = front_wheel_angle_rad_arr[0];
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'front_wheel_angle_rad' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'front_wheel_angle_rad' is wrong type; expected a single.");
    }
    try {
        //rear_wheel_angle_rad
        const matlab::data::TypedArray<float> rear_wheel_angle_rad_arr = arr["rear_wheel_angle_rad"];
        msg->rear_wheel_angle_rad = rear_wheel_angle_rad_arr[0];
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'rear_wheel_angle_rad' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'rear_wheel_angle_rad' is wrong type; expected a single.");
    }
  }
  //----------------------------------------------------------------------------
  MDArray_T ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common::get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::TrajectoryPoint* msg,
       MultiLibLoader loader, size_t size) {
    auto outArray = factory.createStructArray({size,1},{"MessageType","time_from_start","pose","longitudinal_velocity_mps","lateral_velocity_mps","acceleration_mps2","heading_rate_rps","front_wheel_angle_rad","rear_wheel_angle_rad"});
    for(size_t ctr = 0; ctr < size; ctr++){
    outArray[ctr]["MessageType"] = factory.createCharArray("autoware_auto_planning_msgs/TrajectoryPoint");
    // time_from_start
    auto currentElement_time_from_start = (msg + ctr)->time_from_start;
    auto msgClassPtr_time_from_start = getCommonObject<builtin_interfaces::msg::Duration>("ros2_builtin_interfaces_msg_Duration_common",loader);
    outArray[ctr]["time_from_start"] = msgClassPtr_time_from_start->get_arr(factory, &currentElement_time_from_start, loader);
    // pose
    auto currentElement_pose = (msg + ctr)->pose;
    auto msgClassPtr_pose = getCommonObject<geometry_msgs::msg::Pose>("ros2_geometry_msgs_msg_Pose_common",loader);
    outArray[ctr]["pose"] = msgClassPtr_pose->get_arr(factory, &currentElement_pose, loader);
    // longitudinal_velocity_mps
    auto currentElement_longitudinal_velocity_mps = (msg + ctr)->longitudinal_velocity_mps;
    outArray[ctr]["longitudinal_velocity_mps"] = factory.createScalar(currentElement_longitudinal_velocity_mps);
    // lateral_velocity_mps
    auto currentElement_lateral_velocity_mps = (msg + ctr)->lateral_velocity_mps;
    outArray[ctr]["lateral_velocity_mps"] = factory.createScalar(currentElement_lateral_velocity_mps);
    // acceleration_mps2
    auto currentElement_acceleration_mps2 = (msg + ctr)->acceleration_mps2;
    outArray[ctr]["acceleration_mps2"] = factory.createScalar(currentElement_acceleration_mps2);
    // heading_rate_rps
    auto currentElement_heading_rate_rps = (msg + ctr)->heading_rate_rps;
    outArray[ctr]["heading_rate_rps"] = factory.createScalar(currentElement_heading_rate_rps);
    // front_wheel_angle_rad
    auto currentElement_front_wheel_angle_rad = (msg + ctr)->front_wheel_angle_rad;
    outArray[ctr]["front_wheel_angle_rad"] = factory.createScalar(currentElement_front_wheel_angle_rad);
    // rear_wheel_angle_rad
    auto currentElement_rear_wheel_angle_rad = (msg + ctr)->rear_wheel_angle_rad;
    outArray[ctr]["rear_wheel_angle_rad"] = factory.createScalar(currentElement_rear_wheel_angle_rad);
    }
    return std::move(outArray);
  } 
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_TrajectoryPoint_message : public ROS2MsgElementInterfaceFactory {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_TrajectoryPoint_message(){}
    virtual std::shared_ptr<MATLABPublisherInterface> generatePublisherInterface(ElementType /*type*/);
    virtual std::shared_ptr<MATLABSubscriberInterface> generateSubscriberInterface(ElementType /*type*/);
    virtual std::shared_ptr<void> generateCppMessage(ElementType /*type*/, const matlab::data::StructArray& /* arr */, MultiLibLoader /* loader */, std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
    virtual matlab::data::StructArray generateMLMessage(ElementType  /*type*/ ,void*  /* msg */, MultiLibLoader /* loader */ , std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
};  
  std::shared_ptr<MATLABPublisherInterface> 
          ros2_autoware_auto_planning_msgs_TrajectoryPoint_message::generatePublisherInterface(ElementType /*type*/){
    return std::make_shared<ROS2PublisherImpl<autoware_auto_planning_msgs::msg::TrajectoryPoint,ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common>>();
  }
  std::shared_ptr<MATLABSubscriberInterface> 
         ros2_autoware_auto_planning_msgs_TrajectoryPoint_message::generateSubscriberInterface(ElementType /*type*/){
    return std::make_shared<ROS2SubscriberImpl<autoware_auto_planning_msgs::msg::TrajectoryPoint,ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common>>();
  }
  std::shared_ptr<void> ros2_autoware_auto_planning_msgs_TrajectoryPoint_message::generateCppMessage(ElementType /*type*/, 
                                           const matlab::data::StructArray& arr,
                                           MultiLibLoader loader,
                                           std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* commonObjMap){
    auto msg = std::make_shared<autoware_auto_planning_msgs::msg::TrajectoryPoint>();
    ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common commonObj;
    commonObj.mCommonObjMap = commonObjMap;
    commonObj.copy_from_struct(msg.get(), arr[0], loader);
    return msg;
  }
  matlab::data::StructArray ros2_autoware_auto_planning_msgs_TrajectoryPoint_message::generateMLMessage(ElementType  /*type*/ ,
                                                    void*  msg ,
                                                    MultiLibLoader  loader ,
                                                    std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>*  commonObjMap ){
    ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common commonObj;	
    commonObj.mCommonObjMap = commonObjMap;	
    MDFactory_T factory;
    return commonObj.get_arr(factory, (autoware_auto_planning_msgs::msg::TrajectoryPoint*)msg, loader);			
 }
#include "class_loader/register_macro.hpp"
// Register the component with class_loader.
// This acts as a sort of entry point, allowing the component to be discoverable when its library
// is being loaded into a running process.
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_msg_TrajectoryPoint_common, MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::TrajectoryPoint>)
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_TrajectoryPoint_message, ROS2MsgElementInterfaceFactory)
#ifdef _MSC_VER
#pragma warning(pop)
#else
#pragma GCC diagnostic pop
#endif //_MSC_VER