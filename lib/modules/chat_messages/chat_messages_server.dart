import 'dart:convert';
import 'dart:io';

import 'package:business_01/models/chat_messages_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../config/server_config.dart';

class ChatMessageServer{
  bool IsLoaded = false;
  String NextPageURL = '';
  int CurrentPage = 0;
  int LastPage = 0;
  String Message = '';
  var GetChatMessagesRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetChatMessagesURL);
  var SendMessagesRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendMessagesURL);
  var DeleteMessagesRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteMessagesURL);
  var BlockTheChatRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.BlockTheChatURL);
  var UnBlockTheChatRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.UnBlockTheChatURL);
  var DeleteTheChatRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteTheChatURL);


  Future<List<ChatMessage>> GetNewMessages (String Token , int IsFoundation , int ChatId , String NextPageUrl)async{
    var PageUrl ;
    if(NextPageURL == '')
      PageUrl = GetChatMessagesRoute;
    else
      PageUrl = Uri.parse(NextPageUrl);
    try{
      var jsonResponse = await http.post(
        PageUrl,
        headers: {
          'auth-token' : '${Token}',
          'Accept': 'application/json',
        },
        body: {
          'is_foundation' : '${IsFoundation}',
          'chat_id':'${ChatId}'
        }
      );
      if(jsonResponse.statusCode == 200){
        ChatMessagesInfo response = chatMessagesInfoFromJson(jsonResponse.body);
        print(jsonResponse.body);
        if(response.status == true){
          IsLoaded = true;
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          if(response.data.nextPageUrl == null)
            NextPageUrl = '';
          else
            NextPageURL = response.data.nextPageUrl;
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

  Future<bool> SendNewMessage(String Token , int ChatId , int IsFoundation , String MessageTextContent , File? Video , File? Image , int IdOfCommentMessage)async{
    try{
      var jsonResponse = http.MultipartRequest('post',SendMessagesRoute);
      jsonResponse.headers['auth-token'] = '${Token}';
      jsonResponse.headers['Accept'] = 'application/json';
      jsonResponse.fields.addAll({
        'chat_id': "${ChatId}",
        'is_foundation': "${IsFoundation}",
        'message': '${MessageTextContent}',
        'message_replay': IdOfCommentMessage != -1 ? '${IdOfCommentMessage}' : ''
      });
      if (Video != null) {
        var SendVideo = http.MultipartFile.fromBytes(
            'video', Video.readAsBytesSync(),
            filename: Video.path);
        jsonResponse.files.add(SendVideo);
      }
      if (Image != null) {
        var SendImage = http.MultipartFile.fromBytes(
            'photo', Image.readAsBytesSync(),
            filename: Image.path);
        jsonResponse.files.add(SendImage);
      }
        var response = await jsonResponse.send();
      //   int cc = response.contentLength??0;
      //   int cccc = 0;
      // print(cc);
      // response.stream.listen((value) {
      //     cccc += value.length;
      //     print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      //     print(cccc);
      //   }).onData((data) {print(data.length);});

        if (response.statusCode == 200) {
          var ResponseData = await response.stream.toBytes();
          var Result = String.fromCharCodes(ResponseData);
          var Response = jsonDecode(Result);
          print(Response['msg'] );
        if (Response['status'] == true)
            return true;
          return false;
        }else{
          return false;
        }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> DeleteMessage(String Token , int MessageId)async {
    try{
      var jsonResponse = await http.post(
          DeleteMessagesRoute,
        headers: {
            'auth-token' : '${Token}',
          'Accept': 'application/json',
        },
        body: {
            'message_id':'${MessageId}'
       },
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true)
          return true;
        else
          return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
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

  Future<bool>DeleteTheChat(String Token  , BuildContext context , int ChatId)async{
    try{
      var jsonResponse = await http.post(DeleteTheChatRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'chat_id':'${ChatId}',
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
