import 'package:business_01/modules/facility/facility_controller.dart';
import 'package:get/get.dart';

class FacilityBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<FacilityController>(FacilityController());
  }

}