import 'dart:convert';

FacilityMembers facilityMembersFromJson(String str) => FacilityMembers.fromJson(json.decode(str));

String facilityMembersToJson(FacilityMembers data) => json.encode(data.toJson());

class FacilityMembers {
  FacilityMembers({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  var errNum;
  String msg;
  var data;

  factory FacilityMembers.fromJson(Map<String, dynamic> json) => FacilityMembers(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:json["Data"]!=null? Members.fromJson(json["Data"] ): [],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": data.toJson(),
  };
}

class Members {
  Members({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.nextPageUrl,
  });

  int currentPage;
  List<Member> data;
  int lastPage;
  dynamic nextPageUrl;


  factory Members.fromJson(Map<String, dynamic> json) => Members(
    currentPage: json["current_page"],
    data: List<Member>.from(json["data"].map((x) => Member.fromJson(x))),
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

class Member {
  Member({
    required this.name,
    required this.description,
    required this.photo,
    required this.id,
  });

  String name;
  String description;
  dynamic photo;
  int id;


  factory Member.fromJson(Map<String, dynamic> json) => Member(
    name: json["name"],
    description: json["description"],
    photo: json["photo"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "photo": photo,
    "id": id,
  };
}
