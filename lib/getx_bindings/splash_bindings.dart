import 'package:business_01/modules/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }

}