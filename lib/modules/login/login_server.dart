import 'dart:convert';
import 'package:business_01/config/server_config.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class LoginServer{

  var loginRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.LoginURL);
  String message = '';
  bool isConfirm = true;

  Future<bool> SendLoginRequest(String userEmail , String userPassword , BuildContext context , SharedData sharedData)async{
   try{
     var jsonResponse = await http.post(loginRoute,
         headers: {
           'Accept':'application/json',
         },
       body: {
         'email' : userEmail,
         'password' : userPassword
       }
     );
     if(jsonResponse.statusCode == 200){
       var response = jsonDecode(jsonResponse.body);
       if(response['status'] == true){
         message = response['msg'];
         isConfirm = true;
         sharedData.SaveToken(response['Data']['token']);
         sharedData.SaveUserID(response['Data']['id']);
         return true;
       }
       else{
         message = response['msg'];
         if(response['errNum'] == 402)
           isConfirm = false;
         else
           isConfirm = true;
         return false;
       }
     }else{
       message = AppLocalizations.of(context)!.connection_error;
       return false;
     }

   }catch(e){

     message = AppLocalizations.of(context)!.connection_error;
     print(e);
     return false;
   }
  }
}