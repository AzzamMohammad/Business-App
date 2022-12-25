import 'package:get/get.dart';
import '../modules/forger_password/forget_password_controller.dart';

class ForgetPasswordBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<ForgetPasswordController>(ForgetPasswordController());
  }

}