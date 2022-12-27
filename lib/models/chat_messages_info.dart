import 'dart:convert';
import 'dart:io';

import 'package:better_video_player/better_video_player.dart';
import 'package:get/get.dart';

ChatMessagesInfo chatMessagesInfoFromJson(String str) => ChatMessagesInfo.fromJson(json.decode(str));

String chatMessagesInfoToJson(ChatMessagesInfo data) => json.encode(data.toJson());

class ChatMessagesInfo {
  ChatMessagesInfo({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  dynamic data;

  factory ChatMessagesInfo.fromJson(Map<String, dynamic> json) => ChatMessagesInfo(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:json["Data"] != null? Data.fromJson(json["Data"]):null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": data.toJson(),
  };
}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.nextPageUrl,
  });

  int currentPage;
  List<ChatMessage> data;
  int lastPage;
  dynamic nextPageUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<ChatMessage>.from(json["data"].map((x) => ChatMessage.fromJson(x))),
    lastPage: json["last_page"],
    nextPageUrl: json["next_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "last_page": lastPage,
    "next_page_url": nextPageUrl,
  };
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.isFoundation,
    required this.userIsRead,
    required this.foundationIsRead,
    this.message,
    this.photo,
    this.video,
    this.LoadSendImage,
    this.LocalSendVideo,
    this.messageReplay,
    required this.createdAt,
    this.messageTextReplay,
    this.messagePhotoReplay,
    this.messageVideoReplay,
  });

  int id;
  int isFoundation;
  int userIsRead;
  int foundationIsRead;
  dynamic message;
  dynamic photo;
  dynamic video;
  dynamic messageReplay;
  DateTime createdAt;
  dynamic messageTextReplay;
  dynamic messagePhotoReplay;
  dynamic messageVideoReplay;
  File? LoadSendImage;
  File? LocalSendVideo;
  BetterVideoPlayerController betterVideoPlayerController = BetterVideoPlayerController();
  var MessageState = ''.obs;//  Is = 'sending' || 'failed' || 'arrive' || 'read'

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json["id"],
    isFoundation: json["is_foundation"],
    userIsRead: json["user_is_read"],
    foundationIsRead: json["foundation_is_read"],
    message: json["message"],
    photo: json["photo"],
    video: json["video"],
    messageReplay: json["message_replay"],
    createdAt: DateTime.parse(json["created_at"]),
    messageTextReplay: json["message_text_replay"],
    messagePhotoReplay: json["message_photo_replay"],
    messageVideoReplay: json["message_video_replay"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_foundation": isFoundation,
    "user_is_read": userIsRead,
    "foundation_is_read": foundationIsRead,
    "message": message,
    "photo": photo,
    "video": video,
    "message_replay": messageReplay,
    "created_at": createdAt.toIso8601String(),
    "message_text_replay": messageTextReplay,
    "message_photo_replay": messagePhotoReplay,
    "message_video_replay": messageVideoReplay,
  };
}
