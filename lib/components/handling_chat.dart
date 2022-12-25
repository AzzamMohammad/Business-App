import 'dart:convert';
import 'package:business_01/config/pusher_config.dart';
import 'package:pusher_client/pusher_client.dart';

void ListenToThePusherUserChatChannel(int UserId){
  print('ddddddddddddddddddddddddd');
  print(UserId);
  LaravelEcho.instance.private('chatF${UserId}').listen('sendMessage',
      (e){
        print('fkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
    if(e is PusherEvent){
      if(e.data != null){
        print(jsonDecode(e.data!));
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