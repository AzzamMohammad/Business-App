import 'dart:convert';

import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CheckPINServer{
  var checkPinRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.CheckPinURL);
  var ResendPinRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.ResendPINURL);
  String message = '';

  Future<bool> SendPIN(BuildContext context , String PIN , SharedData sharedData)async{
    try{
      var jsonResponse = await http.post(
        checkPinRoute,
        headers: {
          'Accept':'application/json',
        },
        body: {
          'verification_code':'${PIN}',
          'email':"${await sharedData.GetTemporaryEmail()}",
          'password':'${await sharedData.GetTemporaryPassword()}'
        }
      );
      print("${sharedData.GetEmail()}");
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true){
          message = response['msg'];
          sharedData.SaveToken(response['Data']['token']);
          sharedData.SaveUserID(response['Data']['id']);
          return true;
        }else{
          message = response['msg'];
          return false;
        }

      }
      else{
        message = AppLocalizations.of(context)!.connection_error;
        return false;
      }
    }catch(e){
      print(e);
      message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool> ResendPIN(BuildContext context , String Email)async{
    try{
      print(Email);
      var jsonResponse = await http.post(ResendPinRoute,
      headers: {
        'Accept':'application/json',
      },
      body: {
        'email' : '${Email}'
      },);
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true){
          message = response['msg'];
          return true;
        }
        else{
          message = response['msg'];
          return false;
        }

      }
      return false;
    }catch(e){
      print(e);
      message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }
}