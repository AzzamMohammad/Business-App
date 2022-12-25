import 'dart:convert';

FacilityInfo facilityInfoFromJson(String str) => FacilityInfo.fromJson(json.decode(str));

String facilityInfoToJson(FacilityInfo data) => json.encode(data.toJson());

class FacilityInfo {
  FacilityInfo({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  FacilityInformation data;

  factory FacilityInfo.fromJson(Map<String, dynamic> json) => FacilityInfo(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: FacilityInformation.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": data.toJson(),
  };
}

class FacilityInformation {
  FacilityInformation({
    required this.id,
    required this.name,
    required this.photo,
    required this.countriesId,
    required this.citiesId,
    required this.regionsId,
    required this.locationX,
    required this.locationY,
    required this.description,
    required this.createdAt,
    required this.follow,
    required this.country,
    required this.city,
    required this.region,
  });

  int id;
  String name;
  String photo;
  int countriesId;
  int citiesId;
  int regionsId;
  String locationX;
  String locationY;
  String description;
  DateTime createdAt;
  bool follow;
  dynamic country;
  dynamic city;
  dynamic region;

  factory FacilityInformation.fromJson(Map<String, dynamic> json) => FacilityInformation(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
    countriesId: json["countries_id"],
    citiesId: json["cities_id"],
    regionsId: json["regions_id"],
    locationX: json["location_x"],
    locationY: json["location_y"],
    follow:json["follow"]!= null? json["follow"]:false,
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    country: json["country"] != null ? Place.fromJson(json["country"]):Place(id: 0, name: ''),
    city: json["city"] != null? Place.fromJson(json["city"]):Place(id: 0, name: ''),
    region:json["region"]!=null ? Place.fromJson(json["region"]):Place(id: 0, name: ''),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
    "countries_id": countriesId,
    "cities_id": citiesId,
    "regions_id": regionsId,
    "location_x": locationX,
    "location_y": locationY,
    "follow": follow,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "country": country.toJson(),
    "city": city.toJson(),
    "region": region.toJson(),
  };
}

class Place {
  Place({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
