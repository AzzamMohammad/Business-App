import 'dart:convert';

import 'package:business_01/config/server_config.dart';
import 'package:business_01/models/location.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:http/http.dart' as http;

class SplashServer {
  var LoginRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.LoginURL);
  var AllCountriesAndCitiesAndTownsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AllCountriesAndCitiesAndTownsURL);
  var isConfirm = true;
  var GetResponse = false;

  Future<bool> CheckLoginInfo(String Email,String Password ,SharedData sharedData) async {
    try {
      var jsonResponse = await http.post(LoginRoute,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email' : '${Email}',
          'password' : '${Password}'
        },);
      if(jsonResponse.statusCode == 200){
        GetResponse = true;
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true){
          sharedData.SaveToken(response['Data']['token']);
          return true;
        }
        else{
          GetResponse = true;
          if(response['errNum'] == 402)
            isConfirm = false;
          else
            isConfirm = true;
          return false;
        }
      }
      return false;
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<List<Country>> GetAllCountriesAndCitiesAndTowns()async{
    try{
      var jsonResponse = await http.get(AllCountriesAndCitiesAndTownsRoute , headers: {'Accept': 'application/json',});
      print(jsonResponse.statusCode);
      if(jsonResponse.statusCode == 200){
        Location location = locationFromJson(jsonResponse.body);
        if(location.status == true){
          print(location.data);
          return location.data;
        }
        return [];
      }
      return [];
    }catch(e){
      print(e);
      return [];
    }
  }
}