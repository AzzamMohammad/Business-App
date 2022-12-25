import 'dart:convert';

PostsOfFollowingFacility postsOfFollowingFacilityFromJson(String str) => PostsOfFollowingFacility.fromJson(json.decode(str));

String postsOfFollowingFacilityToJson(PostsOfFollowingFacility data) => json.encode(data.toJson());

class PostsOfFollowingFacility {
  PostsOfFollowingFacility({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  var errNum;
  String msg;
  dynamic data;

  factory PostsOfFollowingFacility.fromJson(Map<String, dynamic> json) => PostsOfFollowingFacility(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:json["Data"] != null? Data.fromJson(json["Data"]):[],
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
  dynamic data;
  int lastPage;
  dynamic nextPageUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data:json["data"]!= null? List<FollowFacilityPost>.from(json["data"].map((x) => FollowFacilityPost.fromJson(x))):[],
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

class FollowFacilityPost {
  FollowFacilityPost({
    required this.id,
    required this.foundationId,
    required this.title,
    required this.description,
    required this.photo,
    required this.video,
    required this.createdAt,
    required this.foundationName,
    required this.foundationPhoto,
  });

  int id;
  int foundationId;
  String title;
  String description;
  dynamic photo;
  dynamic video;
  DateTime createdAt;
  String foundationName;
  String foundationPhoto;

  factory FollowFacilityPost.fromJson(Map<String, dynamic> json) => FollowFacilityPost(
    id: json["id"],
    foundationId: json["foundation_id"],
    title: json["title"],
    description: json["description"],
    photo: json["photo"] == null ? null : json["photo"],
    video: json["video"] == null ? null : json["video"],
    createdAt: DateTime.parse(json["created_at"]),
    foundationName: json["foundation_name"] == null ? null : json["foundation_name"],
    foundationPhoto: json["foundation_photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "foundation_id": foundationId,
    "title": title,
    "description": description,
    "photo": photo == null ? null : photo,
    "video": video == null ? null : video,
    "created_at": createdAt.toIso8601String(),
    "foundation_name": foundationName,
    "foundation_photo": foundationPhoto,
  };
}

