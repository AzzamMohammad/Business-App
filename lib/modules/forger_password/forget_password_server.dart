import 'dart:convert';

import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../config/server_config.dart';

class ForgetPasswordServer {
  var ForgetPasswordRoute = Uri.parse(
      ServerConfig.ServerDomain + ServerConfig.ForgetPasswordURL);
  var Message = "";

  Future<bool> ResetPassword(String Pin, String NewPassword,
      String ConfigPassword, SharedData sharedData , BuildContext context) async {
    try {
      var jsonResponse = await http.post(
          ForgetPasswordRoute,
          headers: {
            'Accept': 'application/json',
          },
          body: {
            'verification_code': '${Pin}',
            'password': '${NewPassword}',
            'password_confirmation': '${ConfigPassword}',
            'email':'${await sharedData.GetTemporaryEmail()}'
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status']){
          Message = response['msg'];
          sharedData.SaveToken(response['Data']);
          return true;
        }
        else{
          Message = response['msg'];
          return false;
        }
      }
      else{
        Message = AppLocalizations.of(context)!.connection_error;
        return false;
      }
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }
}