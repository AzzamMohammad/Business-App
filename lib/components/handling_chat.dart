import 'dart:convert';
import 'package:business_01/config/pusher_config.dart';
import 'package:get/get.dart';
import 'package:pusher_client/pusher_client.dart';

import '../models/message_pusher.dart';
import '../modules/chat_messages/chat_messages_controller.dart';

void ListenToThePusherUserChatChannel(int UserId,String Token){
  print(UserId);
  LaravelEcho.instance.channel('chatF${UserId}').listen('.sendMessage',
      (e){
    if(e is PusherEvent){
      if(e.data != null){
        // print(jsonDecode(e.data!));
        HandlingChatMessage(e);
      }
    }
      }
  ).error((err){
    print(err);
  });
}

bool LeavePusherUserChatChannel(int UserId){
  try{
    LaravelEcho.instance.leave('chatF${UserId}');
    return true;
  }catch(e){
    print(e);
    return false;
  }
}

void ListenToThePusherFacilityChatChannel(int UserFacility,String Token){
  LaravelEcho.instance.channel('chatU${UserFacility}').listen('.sendMessage',
          (e){
        if(e is PusherEvent){
          if(e.data != null){
            // print(jsonDecode(e.data!));
            HandlingChatMessage(e);
          }
        }
      }
  ).error((err){
    print(err);
  });
}

bool LeavePusherFacilityChatChannel(int UserFacility){
  try{
    LaravelEcho.instance.leave('chatU${UserFacility}');
    return true;
  }catch(e){
    print(e);
    return false;
  }
}



void HandlingChatMessage(PusherEvent event){
  PusherReceiveEvent pusherReceiveEvent =  PusherReceiveEventFromJson(event.data!);
  print(Get.currentRoute);
  if(Get.currentRoute == '/chat_messages?chat_id=${pusherReceiveEvent.message.chatId}'){
    ChatMessagesController chatMessagesController = Get.find();
    chatMessagesController.AddNewReceiverMessageToChat(pusherReceiveEvent);
  }
}