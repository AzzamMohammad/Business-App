import 'package:business_01/modules/input_email/input_email_controller.dart';
import 'package:get/get.dart';

class InputEmailBiding implements Bindings{
  @override
  void dependencies() {
    Get.put<InputEmailController>(InputEmailController());
  }

}