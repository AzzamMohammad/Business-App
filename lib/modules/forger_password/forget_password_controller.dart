import 'package:business_01/modules/forger_password/forget_password_server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../storage/shared_data.dart';

class ForgetPasswordController extends GetxController{
  late String Pin;
  late String NewPassword;
  late String ConfigNewPassword;
  late SharedData sharedData;
  late bool State;
  late String Message;
  late ForgetPasswordServer forgetPasswordServer;

  @override
  void onInit() {
    Pin = "";
    NewPassword = "";
    ConfigNewPassword = "";
    sharedData = SharedData();
    State = false;
    Message = "";
    forgetPasswordServer = ForgetPasswordServer();
    super.onInit();
  }

  Future<void> ResetPasswordClicked(BuildContext context)async{
    State = await forgetPasswordServer.ResetPassword(Pin,NewPassword,ConfigNewPassword , sharedData , context);
    Message = forgetPasswordServer.Message;
  }
}