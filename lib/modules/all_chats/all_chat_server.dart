import 'dart:convert';

import 'package:business_01/config/server_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../models/all_chats_info.dart';


class ChatServer {
  String Message = '';
  bool IsLoaded = false;
  int CurrentPage = 0;
  int LastPage = 0;
  String NextPageURL = '';

  var GetNewChatsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetNewChatsURL);
  var BlockTheChatRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.BlockTheChatURL);
  var UnBlockTheChatRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.UnBlockTheChatURL);
  var DeleteTheChatRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteTheChatURL);

  Future <List<Chat>> GetChats(String Token , int IsFacility , int Id , String NextPageUrl)async{
    var NextRoute;
    IsLoaded  = false;
    if(NextPageUrl == '')
      NextRoute = GetNewChatsRoute;
    else
      NextRoute = NextPageUrl;
    try{
      var jsonResponse = await http.post(
        NextRoute,
        headers: {
          'auth-token':'${Token}',
          'Accept': 'application/json',
        },
        body: {
          'is_foundation' : '${IsFacility}',
          'id' : '${Id}'
        }
      );
      if(jsonResponse.statusCode == 200){
        var response = allChatsInfoFromJson(jsonResponse.body);
        if(response.status == true){

          IsLoaded = true;
          CurrentPage = response.data.currentPage;

          LastPage = response.data.lastPage;

          NextPageURL = response.data.nextPageUrl == null ? '' : response.data.nextPageUrl;

          return response.data.data;
        }else{
          IsLoaded = false;
          return [];
        }
      }else{
        IsLoaded = false;
        return [];
      }
    }catch(e){
      print(e);
      IsLoaded = false;
      return [];
    }
  }

  Future<bool>BlockTheChat(String Token , int IsFoundation , BuildContext context , int ChatIndex)async{
    try{
      var jsonResponse = await http.post(BlockTheChatRoute,
      headers: {
        'auth-token':'${Token}',
        'Accept': 'application/json',
      },
      body: {
        'chat_id':'${ChatIndex}',
        'is_foundation':'${IsFoundation}'
      });
      if(jsonResponse.statusCode == 200){
       var response = jsonDecode(jsonResponse.body);
       Message = response['msg'];
       if(response['status'] == true){
         return true;
       }else{
         return false;
       }
      }else{
        Message = AppLocalizations.of(context)!.connection_error;
        return false;
      }
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }
  Future<bool>UnBlockTheChat(String Token , int IsFoundation , BuildContext context , int ChatIndex)async{
    try{
      var jsonResponse = await http.post(UnBlockTheChatRoute,
      headers: {
        'auth-token':'${Token}',
        'Accept': 'application/json',
      },
      body: {
        'chat_id':'${ChatIndex}',
        'is_foundation':'${IsFoundation}'
      });
      if(jsonResponse.statusCode == 200){
       var response = jsonDecode(jsonResponse.body);
       Message = response['msg'];
       if(response['status'] == true){
         return true;
       }else{
         return false;
       }
      }else{
        Message = AppLocalizations.of(context)!.connection_error;
        return false;
      }
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool>DeleteTheChat(String Token  , BuildContext context , int ChatIndex)async{
    try{
      var jsonResponse = await http.post(DeleteTheChatRoute,
      headers: {
        'auth-token':'${Token}',
        'Accept': 'application/json',
      },
      body: {
        'chat_id':'${ChatIndex}',
      });
      if(jsonResponse.statusCode == 200){
       var response = jsonDecode(jsonResponse.body);
       Message = response['msg'];
       if(response['status'] == true){
         return true;
       }else{
         return false;
       }
      }else{
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