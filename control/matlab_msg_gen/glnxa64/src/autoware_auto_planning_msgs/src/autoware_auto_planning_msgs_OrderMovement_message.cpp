// Copyright 2020-2022 The MathWorks, Inc.
// Common copy functions for autoware_auto_planning_msgs/OrderMovement
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
#include "autoware_auto_planning_msgs/msg/order_movement.hpp"
#include "visibility_control.h"
#include "class_loader/multi_library_class_loader.hpp"
#include "ROS2PubSubTemplates.hpp"
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_msg_OrderMovement_common : public MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::OrderMovement> {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_msg_OrderMovement_common(){}
    virtual void copy_from_struct(autoware_auto_planning_msgs::msg::OrderMovement* msg, const matlab::data::Struct& arr, MultiLibLoader loader); 
    //----------------------------------------------------------------------------
    virtual MDArray_T get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::OrderMovement* msg, MultiLibLoader loader, size_t size = 1);
};
  void ros2_autoware_auto_planning_msgs_msg_OrderMovement_common::copy_from_struct(autoware_auto_planning_msgs::msg::OrderMovement* msg, const matlab::data::Struct& arr,
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
        //order_movement
        const matlab::data::TypedArray<uint8_t> order_movement_arr = arr["order_movement"];
        msg->order_movement = order_movement_arr[0];
    } catch (matlab::data::InvalidFieldNameException&) {
        throw std::invalid_argument("Field 'order_movement' is missing.");
    } catch (matlab::Exception&) {
        throw std::invalid_argument("Field 'order_movement' is wrong type; expected a uint8.");
    }
  }
  //----------------------------------------------------------------------------
  MDArray_T ros2_autoware_auto_planning_msgs_msg_OrderMovement_common::get_arr(MDFactory_T& factory, const autoware_auto_planning_msgs::msg::OrderMovement* msg,
       MultiLibLoader loader, size_t size) {
    auto outArray = factory.createStructArray({size,1},{"MessageType","NOTSET","STOP","GO","SLOWDOWN","header","order_movement"});
    for(size_t ctr = 0; ctr < size; ctr++){
    outArray[ctr]["MessageType"] = factory.createCharArray("autoware_auto_planning_msgs/OrderMovement");
    // NOTSET
    auto currentElement_NOTSET = (msg + ctr)->NOTSET;
    outArray[ctr]["NOTSET"] = factory.createScalar(currentElement_NOTSET);
    // STOP
    auto currentElement_STOP = (msg + ctr)->STOP;
    outArray[ctr]["STOP"] = factory.createScalar(currentElement_STOP);
    // GO
    auto currentElement_GO = (msg + ctr)->GO;
    outArray[ctr]["GO"] = factory.createScalar(currentElement_GO);
    // SLOWDOWN
    auto currentElement_SLOWDOWN = (msg + ctr)->SLOWDOWN;
    outArray[ctr]["SLOWDOWN"] = factory.createScalar(currentElement_SLOWDOWN);
    // header
    auto currentElement_header = (msg + ctr)->header;
    auto msgClassPtr_header = getCommonObject<std_msgs::msg::Header>("ros2_std_msgs_msg_Header_common",loader);
    outArray[ctr]["header"] = msgClassPtr_header->get_arr(factory, &currentElement_header, loader);
    // order_movement
    auto currentElement_order_movement = (msg + ctr)->order_movement;
    outArray[ctr]["order_movement"] = factory.createScalar(currentElement_order_movement);
    }
    return std::move(outArray);
  } 
class AUTOWARE_AUTO_PLANNING_MSGS_EXPORT ros2_autoware_auto_planning_msgs_OrderMovement_message : public ROS2MsgElementInterfaceFactory {
  public:
    virtual ~ros2_autoware_auto_planning_msgs_OrderMovement_message(){}
    virtual std::shared_ptr<MATLABPublisherInterface> generatePublisherInterface(ElementType /*type*/);
    virtual std::shared_ptr<MATLABSubscriberInterface> generateSubscriberInterface(ElementType /*type*/);
    virtual std::shared_ptr<void> generateCppMessage(ElementType /*type*/, const matlab::data::StructArray& /* arr */, MultiLibLoader /* loader */, std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
    virtual matlab::data::StructArray generateMLMessage(ElementType  /*type*/ ,void*  /* msg */, MultiLibLoader /* loader */ , std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* /*commonObjMap*/);
};  
  std::shared_ptr<MATLABPublisherInterface> 
          ros2_autoware_auto_planning_msgs_OrderMovement_message::generatePublisherInterface(ElementType /*type*/){
    return std::make_shared<ROS2PublisherImpl<autoware_auto_planning_msgs::msg::OrderMovement,ros2_autoware_auto_planning_msgs_msg_OrderMovement_common>>();
  }
  std::shared_ptr<MATLABSubscriberInterface> 
         ros2_autoware_auto_planning_msgs_OrderMovement_message::generateSubscriberInterface(ElementType /*type*/){
    return std::make_shared<ROS2SubscriberImpl<autoware_auto_planning_msgs::msg::OrderMovement,ros2_autoware_auto_planning_msgs_msg_OrderMovement_common>>();
  }
  std::shared_ptr<void> ros2_autoware_auto_planning_msgs_OrderMovement_message::generateCppMessage(ElementType /*type*/, 
                                           const matlab::data::StructArray& arr,
                                           MultiLibLoader loader,
                                           std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>* commonObjMap){
    auto msg = std::make_shared<autoware_auto_planning_msgs::msg::OrderMovement>();
    ros2_autoware_auto_planning_msgs_msg_OrderMovement_common commonObj;
    commonObj.mCommonObjMap = commonObjMap;
    commonObj.copy_from_struct(msg.get(), arr[0], loader);
    return msg;
  }
  matlab::data::StructArray ros2_autoware_auto_planning_msgs_OrderMovement_message::generateMLMessage(ElementType  /*type*/ ,
                                                    void*  msg ,
                                                    MultiLibLoader  loader ,
                                                    std::map<std::string,std::shared_ptr<MATLABROS2MsgInterfaceBase>>*  commonObjMap ){
    ros2_autoware_auto_planning_msgs_msg_OrderMovement_common commonObj;	
    commonObj.mCommonObjMap = commonObjMap;	
    MDFactory_T factory;
    return commonObj.get_arr(factory, (autoware_auto_planning_msgs::msg::OrderMovement*)msg, loader);			
 }
#include "class_loader/register_macro.hpp"
// Register the component with class_loader.
// This acts as a sort of entry point, allowing the component to be discoverable when its library
// is being loaded into a running process.
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_msg_OrderMovement_common, MATLABROS2MsgInterface<autoware_auto_planning_msgs::msg::OrderMovement>)
CLASS_LOADER_REGISTER_CLASS(ros2_autoware_auto_planning_msgs_OrderMovement_message, ROS2MsgElementInterfaceFactory)
#ifdef _MSC_VER
#pragma warning(pop)
#else
#pragma GCC diagnostic pop
#endif //_MSC_VER