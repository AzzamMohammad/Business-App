import 'package:get/get.dart';
import '../modules/facility_images/facility_image_controller.dart';

class FacilityImageBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<FacilityImageController>(FacilityImageController());
  }

}