import 'package:business_01/modules/all_chats/all_chat_server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/all_chats_info.dart';
import '../../storage/shared_data.dart';

class AllChatController extends GetxController {
  late ScrollController ChatsListController;
  late String Message;
  late bool State;
  late ChatServer chatServer;
  late List<Chat> ChatsList;
  late var NumberOfChatsInList;
  late bool ArrivedToLastChat;
  late String NextPageURL;
  late var IsLoaded;
  late int IsFacility;
  late int FacilityId;
  late SharedData sharedData;
  late String Token;

  // late var ChatIsBlocked;
  @override
  void onInit() async {
    ChatsListController = ScrollController();
    Message = '';
    State = false;
    chatServer = ChatServer();
    ChatsList = [];
    NumberOfChatsInList = 0.obs;
    ArrivedToLastChat = false;
    NextPageURL = '';
    IsLoaded = false.obs;
    // ChatIsBlocked = false.obs;
    IsFacility = Get.arguments['is_facility'];
    if(IsFacility == 1)
      FacilityId = Get.arguments['facility_id'];
    else
      FacilityId = 0;
    ChatsListController.addListener(() {
      if (ChatsListController.position.maxScrollExtent ==
          ChatsListController.offset) {
        if (!ArrivedToLastChat)
          GetNewChats();
      }
    });
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    super.onInit();
  }
  @override
  void onReady() {
    GetNewChats();
    super.onReady();
  }



  @override
  void dispose() {
    ChatsListController.dispose();
    super.dispose();
  }

  Future<void> GetNewChats() async {
    State = false;
    List<Chat> NewChats = [] ;
    while (!State) {
      NewChats = await chatServer.GetChats(Token, IsFacility,FacilityId, NextPageURL);
      State = chatServer.IsLoaded;
    }
    IsLoaded(true);
    ChatsList.addAll(NewChats);
    NumberOfChatsInList(ChatsList.length);
    NextPageURL = chatServer.NextPageURL;
    if(chatServer.CurrentPage == chatServer.LastPage)
      ArrivedToLastChat = true;
  }

  Future<void> BlockTheChat(BuildContext context , int index)async{
    State = await chatServer.BlockTheChat(Token,IsFacility,context,index);
    Message = chatServer.Message;
  }

  Future<void> UnBlockTheChat(BuildContext context , int index)async{
    State = await chatServer.UnBlockTheChat(Token,IsFacility,context,index);
    Message = chatServer.Message;
  }

  Future<void> DeleteTheChat(BuildContext context , int index)async{
    State = await chatServer.DeleteTheChat(Token,context,index);
    Message = chatServer.Message;
  }

  Future<void> RefreshAllChatScreen()async{
    IsLoaded(false);
    ChatsList.clear();
    NumberOfChatsInList(0);
    ArrivedToLastChat = false;
    NextPageURL = '';
    GetNewChats();
  }
}