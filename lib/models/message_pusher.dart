import 'dart:convert';

PusherReceiveEvent PusherReceiveEventFromJson(String str) => PusherReceiveEvent.fromJson(json.decode(str));

String PusherReceiveEventToJson(PusherReceiveEvent data) => json.encode(data.toJson());

class PusherReceiveEvent {
  PusherReceiveEvent({
    required this.receive,
    required this.message,
  });

  int receive;
  Message message;

  factory PusherReceiveEvent.fromJson(Map<String, dynamic> json) => PusherReceiveEvent(
    receive: json["receive"],
    message: Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "receive": receive,
    "message": message.toJson(),
  };
}

class Message {
  Message({
    required this.id,
    required this.chatId,
    required this.isFoundation,
    required this.userIsRead,
    required this.foundationIsRead,
    required this.message,
    required this.photo,
    required this.video,
    required this.messageReplay,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int chatId;
  int isFoundation;
  int userIsRead;
  int foundationIsRead;
  String message;
  dynamic photo;
  dynamic video;
  dynamic messageReplay;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    chatId: json["chat_id"],
    isFoundation: json["is_foundation"],
    userIsRead: json["user_is_read"],
    foundationIsRead: json["foundation_is_read"],
    message: json["message"],
    photo: json["photo"],
    video: json["video"],
    messageReplay: json["message_replay"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat_id": chatId,
    "is_foundation": isFoundation,
    "user_is_read": userIsRead,
    "foundation_is_read": foundationIsRead,
    "message": message,
    "photo": photo,
    "video": video,
    "message_replay": messageReplay,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
