import 'dart:convert';

AllChatsInfo allChatsInfoFromJson(String str) => AllChatsInfo.fromJson(json.decode(str));

String allChatsInfoToJson(AllChatsInfo data) => json.encode(data.toJson());

class AllChatsInfo {
  AllChatsInfo({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  ChatsPage data;

  factory AllChatsInfo.fromJson(Map<String, dynamic> json) => AllChatsInfo(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: ChatsPage.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": data.toJson(),
  };
}

class ChatsPage {
  ChatsPage({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.nextPageUrl,

  });

  int currentPage;
  dynamic data;
  int lastPage;
  dynamic nextPageUrl;

  factory ChatsPage.fromJson(Map<String, dynamic> json) => ChatsPage(
    currentPage: json["current_page"],
    data:json["data"]!=null? List<Chat>.from(json["data"].map((x) => Chat.fromJson(x))):[],
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

class Chat {
  Chat({
    required this.id,
    required this.userId,
    required this.foundationId,
    required this.foundationName,
    required this.userName,
    this.foundationPhoto,
    required this.name,
    required this.isBlocked,
    this.lastMessage,
    this.lastMessageIsRead,
    this.createdLastMessage,
    this.dateLastMessage,
    this.timeLastMessage,
  });

  int id;
  int userId;
  int foundationId;
  String foundationName;
  String userName;
  dynamic foundationPhoto;
  String name;
  bool isBlocked;
  dynamic lastMessage;
  dynamic lastMessageIsRead;
  dynamic createdLastMessage;
  dynamic dateLastMessage;
  dynamic timeLastMessage;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    userId: json["user_id"],
    foundationId: json["foundation_id"],
    foundationName: json["foundation_name"],
    userName: json["user_name"],
    foundationPhoto: json["foundation_photo"],
    name: json["name"],
    isBlocked: json["is_blocked"],
    lastMessage: json["last_message"],
    lastMessageIsRead: json["last_message_is_read"],
    createdLastMessage: json["created_last_message"],
    dateLastMessage: json["date_last_message"],
    timeLastMessage: json["time_last_message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "foundation_id": foundationId,
    "foundation_name": foundationName,
    "user_name": userName,
    "foundation_photo": foundationPhoto,
    "name": name,
    "is_blocked": isBlocked,
    "last_message": lastMessage,
    "last_message_is_read": lastMessageIsRead,
    "created_last_message": createdLastMessage,
    "date_last_message": dateLastMessage,
    "time_last_message": timeLastMessage,
  };
}

