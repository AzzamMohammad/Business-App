import 'dart:convert';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../config/server_config.dart';
import '../../models/user.dart';

class RegisterServer {
  late String message = "";
  var RegisterUrl = Uri.parse(ServerConfig.ServerDomain + ServerConfig.RegisterURL);



  Future<bool> SendRegister(User user , BuildContext context,SharedData sharedData) async {
    try{
      print("${user.countryCodeNumber}${user.phoneNumber}");
      print("${user.email}");
      var response = await http.post(
          RegisterUrl,
          headers: {
            'Accept':'application/json',
          },

          body: {
            'email': '${user.email}',
            'password' : '${user.password}',
            'f_name' :'${user.firstName}',
            'l_name' : '${user.lastName}',
            'city' : '${user.city}',
            'country' : '${user.country}',
            'region' : '${user.town}',
            'date_of_birth': DateFormat('yyyy-MM-dd').format(user.dateOfBirth),
            'gender':user.userGender == 'Male'||user.userGender == 'ذكر' ? 'M' :'F' ,
            'mobile_phone_Number' : user.phoneNumber == null ? '' : '${user.countryCodeNumber}${user.phoneNumber}',
            'address': '${user.locationDescription}',
          }
      );

      print("${user.countryCodeNumber}${user.phoneNumber}");
      print("${user.email}");
      print(response.statusCode);
      if(response.statusCode == 200){
        var responseData = jsonDecode(response.body);
        if(responseData['status'] == true){

          message = responseData['msg'];
          return true;
        }
        else{
          message = responseData['msg'];
          return false;
        }

      }else{
        message = AppLocalizations.of(context)!.connection_error;
        return false;
      }

    }catch(e){
      print(RegisterUrl);
      print(e);
      message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }
}
