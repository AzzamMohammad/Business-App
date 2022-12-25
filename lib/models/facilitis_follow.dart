
import 'dart:convert';

FacilitisFollow facilitisFollowFromJson(String str) => FacilitisFollow.fromJson(json.decode(str));

String facilitisFollowToJson(FacilitisFollow data) => json.encode(data.toJson());

class FacilitisFollow {
  FacilitisFollow({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  var errNum;
  String msg;
  dynamic data;

  factory FacilitisFollow.fromJson(Map<String, dynamic> json) => FacilitisFollow(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: json["Data"] != null ? Data.fromJson(json["Data"]): [],
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
    data: json["data"] != null ? List<FacilityFollow>.from(json["data"].map((x) => FacilityFollow.fromJson(x))):[],
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

class FacilityFollow {
  FacilityFollow({
    required this.id,
    required this.name,
    required this.photo,
  });

  int id;
  String name;
  String photo;

  factory FacilityFollow.fromJson(Map<String, dynamic> json) => FacilityFollow(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
  };
}

