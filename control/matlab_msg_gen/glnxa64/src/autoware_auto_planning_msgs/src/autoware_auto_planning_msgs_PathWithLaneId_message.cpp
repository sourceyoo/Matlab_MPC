// Copyright 2020-2022 The MathWorks, Inc.
// Common copy functions for autoware_auto_planning_msgs/PathWithLaneId
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
#include "autoware_auto_planning_msgs/msg/path_with_lane_id.hpp"
#include "visibility_control.h"
#include "class_loader/multi_library_class_loader.hpp"
#include "ROS2PubSubTemplates.hpp"
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common : public MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::PathWithLaneId> {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common(){}
    virtual void copy_from_struct(autoware_auto_planning_msgs::msg::PathWithLaneId* msg, const matlab::data::Struct& arr, MultiLibLoader loader); 
    //----------------------------------------------------------------------------
    virtual MDArray_T get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::PathWithLaneId* msg, MultiLibLoader loader, size_t size = 1);
};
  void ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common::copy_from_struct(autoware_auto_planning_msgs::msg::PathWithLaneId* msg, const matlab::data::Struct& arr,
               MultiLibLoader loader) {
    try {
        //header
        const matlab::data::StructArray header_arr = arr["header"];
        auto msgClassPtr_header = getCommonObject<std_msgs::msg::Header>("ros2_std_msgs_msg_Header_common",loader);
        msgClassPtr_header->copy_from_struct(&msg->header,header_arr[0],loader);
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'header' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'header' is wrong type; expected a struct.");
    }
    try {
        //points
        const matlab::data::StructArray points_arr = arr["points"];
        for (auto _pointsarr : points_arr) {
        	autoware_auto_planning_msgs::msg::PathPointWithLaneId _val;
        auto msgClassPtr_points = getCommonObject<autoware_auto_planning_msgs::msg::PathPointWithLaneId>("ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common",loader);
        msgClassPtr_points->copy_from_struct(&_val,_pointsarr,loader);
        	msg->points.push_back(_val);
        }
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'points' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'points' is wrong type; expected a struct.");
    }
    try {
        //left_bound
        const matlab::data::StructArray left_bound_arr = arr["left_bound"];
        for (auto _left_boundarr : left_bound_arr) {
        	geometry_msgs::msg::Point _val;
        auto msgClassPtr_left_bound = getCommonObject<geometry_msgs::msg::Point>("ros2_geometry_msgs_msg_Point_common",loader);
        msgClassPtr_left_bound->copy_from_struct(&_val,_left_boundarr,loader);
        	msg->left_bound.push_back(_val);
        }
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'left_bound' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'left_bound' is wrong type; expected a struct.");
    }
    try {
        //right_bound
        const matlab::data::StructArray right_bound_arr = arr["right_bound"];
        for (auto _right_boundarr : right_bound_arr) {
        	geometry_msgs::msg::Point _val;
        auto msgClassPtr_right_bound = getCommonObject<geometry_msgs::msg::Point>("ros2_geometry_msgs_msg_Point_common",loader);
        msgClassPtr_right_bound->copy_from_struct(&_val,_right_boundarr,loader);
        	msg->right_bound.push_back(_val);
        }
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'right_bound' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'right_bound' is wrong type; expected a struct.");
    }
  }
  //----------------------------------------------------------------------------
  MDArray_T ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common::get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::PathWithLaneId* msg,
       MultiLibLoader loader, size_t size) {
    auto outArray = factory.createStructArray({size,1},{"MessageType","header","points","left_bound","right_bound"});
    for(size_t ctr = 0; ctr < size; ctr++){
    outArray[ctr]["MessageType"] = factory.createCharArray("autoware_auto_planning_msgs/PathWithLaneId");
    // header
    auto currentElement_header = (msg + ctr)->header;
    auto msgClassPtr_header = getCommonObject<std_msgs::msg::Header>("ros2_std_msgs_msg_Header_common",loader);
    outArray[ctr]["header"] = msgClassPtr_header->get_arr(factory, &currentElement_header, loader);
    // points
    auto currentElement_points = (msg + ctr)->points;
    auto msgClassPtr_points = getCommonObject<autoware_auto_planning_msgs::msg::PathPointWithLaneId>("ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common",loader);
    outArray[ctr]["points"] = msgClassPtr_points->get_arr(factory,&currentElement_points[0],loader,currentElement_points.size());
    // left_bound
    auto currentElement_left_bound = (msg + ctr)->left_bound;
    auto msgClassPtr_left_bound = getCommonObject<geometry_msgs::msg::Point>("ros2_geometry_msgs_msg_Point_common",loader);
    outArray[ctr]["left_bound"] = msgClassPtr_left_bound->get_arr(factory,&currentElement_left_bound[0],loader,currentElement_left_bound.size());
    // right_bound
    auto currentElement_right_bound = (msg + ctr)->right_bound;
    auto msgClassPtr_right_bound = getCommonObject<geometry_msgs::msg::Point>("ros2_geometry_msgs_msg_Point_common",loader);
    outArray[ctr]["right_bound"] = msgClassPtr_right_bound->get_arr(factory,&currentElement_right_bound[0],loader,currentElement_right_bound.size());
    }
    return std::move(outArray);
  } 
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_PathWithLaneId_message : public ROS2MsgElementInterfaceFactory {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_PathWithLaneId_message(){}
    virtual std::shared_ptr<MATLABPublisherInterface> generatePublisherInterface(ElementType /*type*/);
    virtual std::shared_ptr<MATLABSubscriberInterface> generateSubscriberInterface(ElementType /*type*/);
    virtual std::shared_ptr<void> generateCppMessage(ElementType /*type*/, const matlab::data::StructArray& /* arr */, MultiLibLoader /* loader */, std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
    virtual matlab::data::StructArray generateMLMessage(ElementType  /*type*/ ,void*  /* msg */, MultiLibLoader /* loader */ , std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
};  
  std::shared_ptr<MATLABPublisherInterface> 
          ros2_autoware_auto_planning_msgs_PathWithLaneId_message::generatePublisherInterface(ElementType /*type*/){
    return std::make_shared<ROS2PublisherImpl<autoware_auto_planning_msgs::msg::PathWithLaneId,ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common>>();
  }
  std::shared_ptr<MATLABSubscriberInterface> 
         ros2_autoware_auto_planning_msgs_PathWithLaneId_message::generateSubscriberInterface(ElementType /*type*/){
    return std::make_shared<ROS2SubscriberImpl<autoware_auto_planning_msgs::msg::PathWithLaneId,ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common>>();
  }
  std::shared_ptr<void> ros2_autoware_auto_planning_msgs_PathWithLaneId_message::generateCppMessage(ElementType /*type*/, 
                                           const matlab::data::StructArray& arr,
                                           MultiLibLoader loader,
                                           std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* commonObjMap){
    auto msg = std::make_shared<autoware_auto_planning_msgs::msg::PathWithLaneId>();
    ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common commonObj;
    commonObj.mCommonObjMap = commonObjMap;
    commonObj.copy_from_struct(msg.get(), arr[0], loader);
    return msg;
  }
  matlab::data::StructArray ros2_autoware_auto_planning_msgs_PathWithLaneId_message::generateMLMessage(ElementType  /*type*/ ,
                                                    void*  msg ,
                                                    MultiLibLoader  loader ,
                                                    std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>*  commonObjMap ){
    ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common commonObj;	
    commonObj.mCommonObjMap = commonObjMap;	
    MDFactory_T factory;
    return commonObj.get_arr(factory, (autoware_auto_planning_msgs::msg::PathWithLaneId*)msg, loader);			
 }
#include "class_loader/register_macro.hpp"
// Register the component with class_loader.
// This acts as a sort of entry point, allowing the component to be discoverable when its library
// is being loaded into a running process.
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_msg_PathWithLaneId_common, MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::PathWithLaneId>)
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_PathWithLaneId_message, ROS2MsgElementInterfaceFactory)
#ifdef _MSC_VER
#pragma warning(pop)
#else
#pragma GCC diagnostic pop
#endif //_MSC_VER