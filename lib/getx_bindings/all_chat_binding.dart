import 'package:business_01/modules/all_chats/all_chat_controller.dart';
import 'package:get/get.dart';

class AllChatBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AllChatController>(AllChatController());
  }

}