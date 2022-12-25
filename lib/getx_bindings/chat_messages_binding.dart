import 'package:get/get.dart';

import '../modules/chat_messages/chat_messages_controller.dart';

class ChatMessagesBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<ChatMessagesController>(ChatMessagesController());
  }

}