import 'package:business_01/modules/search/search_controller.dart';
import 'package:get/get.dart';

class SearchBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<SearchController>(SearchController());
  }

}