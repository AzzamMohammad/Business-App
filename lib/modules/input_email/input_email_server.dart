import 'dart:convert';

import 'package:business_01/config/server_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class InputEmailServer{
  var InputEmailRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.InputEmailToSendPINURL);
  String Message = '';

  Future<bool> InputEmail(BuildContext context , String Email)async{
    try{
      var jsonResponse = await http.post(InputEmailRoute,headers: {
        'Accept':'application/json',
      },
      body: {
        'email' : '${Email}',
      });
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true){
          Message = response['msg'];
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