import 'dart:io';

import 'package:better_video_player/better_video_player.dart';
import 'package:business_01/modules/chat_messages/chat_messages_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_messages_info.dart';
import '../../models/message_pusher.dart';

class ChatMessagesController extends GetxController {
  late SharedData sharedData;
  late String Token;
  late ScrollController MessageListController;
  late List<ChatMessage> ChatMessagesList;
  late bool ArrivedToEndOfList;
  late var NumberOfMessagesInList;
  late bool State;
  late String Message;
  late String NextPageUrl;
  late BetterVideoPlayerController betterVideoPlayerController;
  late ChatMessageServer chatMessageServer;
  late var IsLoaded;
  late String UserName;
  late String? UserImageUrl;
  late var ChatIsBlocked;
  late int ChatId;
  late int IsFoundation;
  late File? LoadingVideo;
  late File? LoadingImage;
  late String MessageTextContent;
  late int IdOfCommentMessage;
  late bool ReseveChatIsBlocked;
  late TextEditingController MessageFieldController;

  late var CommentMessage;

  @override
  void onInit() async {
    ChatMessagesList = [];
    ArrivedToEndOfList = false;
    NumberOfMessagesInList = 0.obs;
    NextPageUrl = '';
    State = false;
    Message = '';
    MessageListController = ScrollController();
    betterVideoPlayerController = BetterVideoPlayerController();
    chatMessageServer = ChatMessageServer();
    IsLoaded = false.obs;
    UserName = Get.arguments['User_name'];
    UserImageUrl = Get.arguments['user_image'];
    ChatId = int.parse(Get.parameters['chat_id']!);
    IsFoundation = Get.arguments['IsFoundation'];
    ReseveChatIsBlocked = Get.arguments['Chat_is_blocked'];
    ChatIsBlocked = ReseveChatIsBlocked.obs;
    LoadingVideo = null;
    LoadingImage = null;
    MessageTextContent = '';
    IdOfCommentMessage = -1;
    CommentMessage = 1000000000000.obs;
    MessageFieldController = TextEditingController();
    MessageListController.addListener(() {
      if (MessageListController.position.maxScrollExtent ==
          MessageListController.offset) {
        if (!ArrivedToEndOfList) GetNewMessages();
      }
    });
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    super.onInit();
  }

  @override
  void onReady() async {
    await GetNewMessages();
    super.onReady();
  }

  @override
  void dispose() {
    MessageFieldController.dispose();
    MessageListController.dispose();
    for (int i = 0; i < ChatMessagesList.length; i++) {
      ChatMessagesList[i].betterVideoPlayerController.dispose();
    }

    super.dispose();
  }

  Future<void> GetNewMessages() async {
    State = false;
    List<ChatMessage> NewMessages = [];
    while (!State) {
      NewMessages = await chatMessageServer.GetNewMessages(
          Token, IsFoundation, ChatId, NextPageUrl);
      State = chatMessageServer.IsLoaded;
    }
    for (ChatMessage ch in NewMessages) {
      if (ch.isFoundation == IsFoundation) {
        if (IsFoundation == 0) {
          if (ch.foundationIsRead == 1)
            ch.MessageState('read');
          else
            ch.MessageState('arrive');
        } else {
          if (ch.userIsRead == 1)
            ch.MessageState('read');
          else
            ch.MessageState('arrive');
        }
        print(ch.foundationIsRead);
        print(IsFoundation);
      }
    }

    ChatMessagesList.addAll(NewMessages);
    NumberOfMessagesInList(ChatMessagesList.length);
    NextPageUrl = chatMessageServer.NextPageURL;
    IsLoaded(true);
    if (chatMessageServer.CurrentPage == chatMessageServer.LastPage)
      ArrivedToEndOfList = true;
  }

  Future<void> SendNewMessage() async {
    ChatMessage NewMessage = ChatMessage(
        id: 500,
        isFoundation: IsFoundation,
        userIsRead: IsFoundation == 0 ? 1 : 0,
        foundationIsRead: IsFoundation == 1 ? 1 : 0,
        createdAt: DateTime.now(),
        message: MessageTextContent,
        LocalSendVideo: LoadingVideo ,
        LoadSendImage: LoadingImage ,
        messageTextReplay: CommentMessage.value != 1000000000000
            ? ChatMessagesList[CommentMessage.value].message
            : null,
        messagePhotoReplay: CommentMessage.value != 1000000000000
            ? ChatMessagesList[CommentMessage.value].photo
            : null,
        messageVideoReplay: CommentMessage.value != 1000000000000
            ? ChatMessagesList[CommentMessage.value].video
            : null,
        messageReplay:
            CommentMessage.value != 1000000000000 ? CommentMessage.value : -1,

    );
    NewMessage.MessageState('sending');
    ChatMessagesList.insert(0, NewMessage);
    NumberOfMessagesInList(ChatMessagesList.length);
    CommentMessage(1000000000000);
    MessageFieldController.clear();
    State = await chatMessageServer.SendNewMessage(Token, ChatId, IsFoundation,
        MessageTextContent, LoadingVideo, LoadingImage, IdOfCommentMessage);
    if (State == false) {
      NewMessage.MessageState('failed');
    } else {
      NewMessage.MessageState('arrive');
    }
  }

  Future<void> ReSendMessage(int index) async {
    ChatMessagesList[index].MessageState('sending');
    State = await chatMessageServer.SendNewMessage(
        Token,
        ChatMessagesList[index].id,
        IsFoundation,
        ChatMessagesList[index].message,
        ChatMessagesList[index].video,
        ChatMessagesList[index].photo,
        ChatMessagesList[index].messageReplay);
    if (State == false) {
      ChatMessagesList[index].MessageState('failed');
    } else {
      ChatMessagesList[index].MessageState('arrive');
    }
  }

  void DeleteMessage(int MessageId, int index) async {
    ChatMessagesList.removeAt(index);
    NumberOfMessagesInList(ChatMessagesList.length);
    State = false;
    while (!State) {
      State = await chatMessageServer.DeleteMessage(Token, MessageId);
      print(State);
    }
  }

  Future<void> BlockTheChat(BuildContext context, int index) async {
    State = await chatMessageServer.BlockTheChat(
        Token, IsFoundation, context, index);
    Message = chatMessageServer.Message;
  }

  Future<void> UnBlockTheChat(BuildContext context, int index) async {
    State = await chatMessageServer.UnBlockTheChat(
        Token, IsFoundation, context, index);
    Message = chatMessageServer.Message;
  }

  Future<void> DeleteTheChat(BuildContext context, int ChatId) async {
    State = await chatMessageServer.DeleteTheChat(Token, context, ChatId);
    Message = chatMessageServer.Message;
  }

  void AddNewReceiverMessageToChat(PusherReceiveEvent message) {
    ChatMessage newMessage = ChatMessage(
        id: message.message.id,
        isFoundation: message.message.isFoundation,
        userIsRead: message.message.userIsRead,
        foundationIsRead: message.message.foundationIsRead,
        createdAt: message.message.createdAt,
        messageReplay: message.message.messageReplay,
        video: message.message.video,
        photo: message.message.photo,
        message: message.message.message);
    ChatMessagesList.insert(0, newMessage);
    // ChatMessagesList[ChatMessagesList.length].MessageState('read');
    NumberOfMessagesInList(ChatMessagesList.length);
    print(ChatMessagesList[0].message);
  }
}
