import 'package:business_01/modules/check_PIN/check_PIN_controller.dart';
import 'package:get/get.dart';

class CheckPINBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<CheckPINController>(CheckPINController());
  }

}