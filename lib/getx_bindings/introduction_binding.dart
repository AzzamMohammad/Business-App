import 'package:business_01/modules/introduction/introduction_controller.dart';
import 'package:get/get.dart';

class IntroductionBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<IntroductionController>(IntroductionController());
  }

}