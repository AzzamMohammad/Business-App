import 'package:business_01/modules/home_page/home_page_controller.dart';
import 'package:get/get.dart';

class HomePageBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<HomePageController>(HomePageController());
  }
}