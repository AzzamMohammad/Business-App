import 'dart:convert';

FacilityPostsPagination facilityPostsPaginationFromJson(String str) => FacilityPostsPagination.fromJson(json.decode(str));

String facilityPostsPaginationToJson(FacilityPostsPagination data) => json.encode(data.toJson());

class FacilityPostsPagination {
  FacilityPostsPagination({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  Data data;

  factory FacilityPostsPagination.fromJson(Map<String, dynamic> json) => FacilityPostsPagination(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: Data.fromJson(json["Data"]),
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
  List<PostInfo> data;
  int lastPage;
  dynamic nextPageUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<PostInfo>.from(json["data"].map((x) => PostInfo.fromJson(x))),
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

class PostInfo {
  PostInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.video,
    required this.createdAt,
  });

  int id;
  String title;
  String description;
  String? photo;
  String? video;
  DateTime createdAt;

  factory PostInfo.fromJson(Map<String, dynamic> json) => PostInfo(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    photo: json["photo"],
    video: json["video"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "photo": photo,
    "video": video,
    "created_at": createdAt.toIso8601String(),
  };
}
