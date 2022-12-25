import 'dart:convert';

import 'package:business_01/config/server_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../components/handling_chat.dart';


class LogoutServer{
  var LogoutRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.LogoutURL);
  String message ='';

  Future<bool> Logout(String Token,BuildContext context,int UserID)async{
    try{
      var jsonResponse = await http.post(
        LogoutRoute,
        headers: {
          'auth-token':'${Token}',
          'Accept':'application/json',
        }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status']){
         bool PusherLogoutState = LeavePusherUserChatChannel(UserID);
         if(PusherLogoutState){
           return true;
         }else{
           message = AppLocalizations.of(context)!.connection_error;
           return false;
         }
        }else{
          message = AppLocalizations.of(context)!.connection_error;
          return false;
        }
      }else{
        message = AppLocalizations.of(context)!.connection_error;
        return false;
      }
    }catch(e){
      print(e);
      message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }
}