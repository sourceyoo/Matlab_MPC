// Copyright 2020-2022 The MathWorks, Inc.
// Common copy functions for autoware_auto_planning_msgs/PathPointWithLaneId
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
#include "autoware_auto_planning_msgs/msg/path_point_with_lane_id.hpp"
#include "visibility_control.h"
#include "class_loader/multi_library_class_loader.hpp"
#include "ROS2PubSubTemplates.hpp"
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common : public MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::PathPointWithLaneId> {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common(){}
    virtual void copy_from_struct(autoware_auto_planning_msgs::msg::PathPointWithLaneId* msg, const matlab::data::Struct& arr, MultiLibLoader loader); 
    //----------------------------------------------------------------------------
    virtual MDArray_T get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::PathPointWithLaneId* msg, MultiLibLoader loader, size_t size = 1);
};
  void ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common::copy_from_struct(autoware_auto_planning_msgs::msg::PathPointWithLaneId* msg, const matlab::data::Struct& arr,
               MultiLibLoader loader) {
    try {
        //point
        const matlab::data::StructArray point_arr = arr["point"];
        auto msgClassPtr_point = getCommonObject<autoware_auto_planning_msgs::msg::PathPoint>("ros2_autoware_auto_planning_msgs_msg_PathPoint_common",loader);
        msgClassPtr_point->copy_from_struct(&msg->point,point_arr[0],loader);
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'point' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'point' is wrong type; expected a struct.");
    }
    try {
        //lane_ids
        const matlab::data::TypedArray<int64_t> lane_ids_arr = arr["lane_ids"];
        size_t nelem = lane_ids_arr.getNumberOfElements();
        	msg->lane_ids.resize(nelem);
        	std::copy(lane_ids_arr.begin(), lane_ids_arr.begin()+nelem, msg->lane_ids.begin());
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'lane_ids' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'lane_ids' is wrong type; expected a int64.");
    }
  }
  //----------------------------------------------------------------------------
  MDArray_T ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common::get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::PathPointWithLaneId* msg,
       MultiLibLoader loader, size_t size) {
    auto outArray = factory.createStructArray({size,1},{"MessageType","point","lane_ids"});
    for(size_t ctr = 0; ctr < size; ctr++){
    outArray[ctr]["MessageType"] = factory.createCharArray("autoware_auto_planning_msgs/PathPointWithLaneId");
    // point
    auto currentElement_point = (msg + ctr)->point;
    auto msgClassPtr_point = getCommonObject<autoware_auto_planning_msgs::msg::PathPoint>("ros2_autoware_auto_planning_msgs_msg_PathPoint_common",loader);
    outArray[ctr]["point"] = msgClassPtr_point->get_arr(factory, &currentElement_point, loader);
    // lane_ids
    auto currentElement_lane_ids = (msg + ctr)->lane_ids;
    outArray[ctr]["lane_ids"] = factory.createArray<autoware_auto_planning_msgs::msg::PathPointWithLaneId::_lane_ids_type::const_iterator, int64_t>({currentElement_lane_ids.size(), 1}, currentElement_lane_ids.begin(), currentElement_lane_ids.end());
    }
    return std::move(outArray);
  } 
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_PathPointWithLaneId_message : public ROS2MsgElementInterfaceFactory {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_PathPointWithLaneId_message(){}
    virtual std::shared_ptr<MATLABPublisherInterface> generatePublisherInterface(ElementType /*type*/);
    virtual std::shared_ptr<MATLABSubscriberInterface> generateSubscriberInterface(ElementType /*type*/);
    virtual std::shared_ptr<void> generateCppMessage(ElementType /*type*/, const matlab::data::StructArray& /* arr */, MultiLibLoader /* loader */, std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
    virtual matlab::data::StructArray generateMLMessage(ElementType  /*type*/ ,void*  /* msg */, MultiLibLoader /* loader */ , std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
};  
  std::shared_ptr<MATLABPublisherInterface> 
          ros2_autoware_auto_planning_msgs_PathPointWithLaneId_message::generatePublisherInterface(ElementType /*type*/){
    return std::make_shared<ROS2PublisherImpl<autoware_auto_planning_msgs::msg::PathPointWithLaneId,ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common>>();
  }
  std::shared_ptr<MATLABSubscriberInterface> 
         ros2_autoware_auto_planning_msgs_PathPointWithLaneId_message::generateSubscriberInterface(ElementType /*type*/){
    return std::make_shared<ROS2SubscriberImpl<autoware_auto_planning_msgs::msg::PathPointWithLaneId,ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common>>();
  }
  std::shared_ptr<void> ros2_autoware_auto_planning_msgs_PathPointWithLaneId_message::generateCppMessage(ElementType /*type*/, 
                                           const matlab::data::StructArray& arr,
                                           MultiLibLoader loader,
                                           std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* commonObjMap){
    auto msg = std::make_shared<autoware_auto_planning_msgs::msg::PathPointWithLaneId>();
    ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common commonObj;
    commonObj.mCommonObjMap = commonObjMap;
    commonObj.copy_from_struct(msg.get(), arr[0], loader);
    return msg;
  }
  matlab::data::StructArray ros2_autoware_auto_planning_msgs_PathPointWithLaneId_message::generateMLMessage(ElementType  /*type*/ ,
                                                    void*  msg ,
                                                    MultiLibLoader  loader ,
                                                    std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>*  commonObjMap ){
    ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common commonObj;	
    commonObj.mCommonObjMap = commonObjMap;	
    MDFactory_T factory;
    return commonObj.get_arr(factory, (autoware_auto_planning_msgs::msg::PathPointWithLaneId*)msg, loader);			
 }
#include "class_loader/register_macro.hpp"
// Register the component with class_loader.
// This acts as a sort of entry point, allowing the component to be discoverable when its library
// is being loaded into a running process.
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_msg_PathPointWithLaneId_common, MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::PathPointWithLaneId>)
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_PathPointWithLaneId_message, ROS2MsgElementInterfaceFactory)
#ifdef _MSC_VER
#pragma warning(pop)
#else
#pragma GCC diagnostic pop
#endif //_MSC_VER