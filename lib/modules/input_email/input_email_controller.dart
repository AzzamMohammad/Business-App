import 'package:business_01/modules/input_email/input_email_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InputEmailController extends GetxController{
  late String Email ;
  late String Message;
  late bool State;
  late InputEmailServer inputEmailServer;
  late SharedData sharedData;
  @override
  void onInit() {
    Email = '';
    Message = '';
    State = false;
    inputEmailServer = InputEmailServer();
    sharedData = SharedData();
    super.onInit();
  }

  Future<void> SendPinClicked(BuildContext context)async{
    State = await inputEmailServer.InputEmail(context, Email);
    Message = inputEmailServer.Message;
  }
}