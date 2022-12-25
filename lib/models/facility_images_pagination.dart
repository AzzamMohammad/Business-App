import 'dart:convert';

FacilityPhotosPagination facilityPhotosPaginationFromJson(String str) => FacilityPhotosPagination.fromJson(json.decode(str));

String facilityPhotosPaginationToJson(FacilityPhotosPagination data) => json.encode(data.toJson());

class FacilityPhotosPagination {
  FacilityPhotosPagination({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  Data data;

  factory FacilityPhotosPagination.fromJson(Map<String, dynamic> json) => FacilityPhotosPagination(
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
  dynamic data;

  int lastPage;


  dynamic nextPageUrl;






  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data:json["data"]!=null? List<FacilityImage>.from(json["data"].map((x) => FacilityImage.fromJson(x))):[],

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

class FacilityImage {
  FacilityImage({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.createdAt,
  });

  int id;
  String title;
  String description;
  String photo;
  DateTime createdAt;

  factory FacilityImage.fromJson(Map<String, dynamic> json) => FacilityImage(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    photo: json["photo"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "photo": photo,
    "created_at": createdAt.toIso8601String(),
  };
}
