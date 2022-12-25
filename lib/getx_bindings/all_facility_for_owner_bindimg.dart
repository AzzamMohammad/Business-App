import 'package:get/get.dart';
import '../modules/all_facility-for_owner_drawer/all_facility_for_owner_controller.dart';

class AllFacilityForOwnerBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AllFacilityForOwnerController>(AllFacilityForOwnerController());
  }

}