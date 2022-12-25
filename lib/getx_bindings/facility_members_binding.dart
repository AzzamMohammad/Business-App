import 'package:business_01/modules/facility_members/facility_member_controller.dart';
import 'package:get/get.dart';

class FacilityMembersBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<FacilityMemberController>(FacilityMemberController());
  }

}