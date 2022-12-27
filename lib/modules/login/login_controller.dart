import 'package:business_01/modules/login/login_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/handling_chat.dart';
import '../../config/pusher_config.dart';

class LoginController extends GetxController{

  late String userEmail;
  late String userPassword;
  late LoginServer loginServer;
  late bool state;
  late String message;
  late bool isConfirm;
  late SharedData sharedData;

  @override
  void onInit() {
    userEmail = '';
    userPassword = '';
    state = false;
    message = '';
    isConfirm = false;
    sharedData = SharedData();
    loginServer = LoginServer();
    super.onInit();
  }

  Future<void> LoginClicked(BuildContext context)async{
   state = await loginServer.SendLoginRequest(userEmail, userPassword, context , sharedData);
   message = loginServer.message;
   isConfirm = loginServer.isConfirm;
   if(state == true){
     LaravelEcho.init(Token: await sharedData.GetToken());
     ListenToThePusherUserChatChannel(await sharedData.GetUserID() ,await sharedData.GetToken());
   }
  }

}