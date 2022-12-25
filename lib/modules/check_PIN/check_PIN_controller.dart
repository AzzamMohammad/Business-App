import 'package:business_01/modules/check_PIN/check_PIN_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../config/pusher_config.dart';
class CheckPINController extends GetxController {
  late String PIN;
  late bool stateNext;
  late String messageNext;
  late bool stateResend;
  late String messageResend;
  late CheckPINServer checkPINServer;
  late SharedData sharedData ;
  late String Token;

  @override
  void onInit() {
    PIN = '';
    stateNext = false;
    messageNext = '';
    stateResend = false;
    messageResend = '';
    Token = '';
    sharedData = SharedData();
    checkPINServer = CheckPINServer();
    super.onInit();
  }


  Future<void> SendClicked(BuildContext context)async{
    stateNext = await checkPINServer.SendPIN(context, PIN , sharedData);
    messageNext = checkPINServer.message;
    if(stateNext == true){
      LaravelEcho.init(Token: await sharedData.GetToken());
    }
  }

  Future<void> ResendClicked(BuildContext context)async{
    stateResend = await checkPINServer.ResendPIN(context, await sharedData.GetTemporaryEmail());
    messageResend = checkPINServer.message;

  }
}
