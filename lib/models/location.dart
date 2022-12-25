import 'dart:convert';

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  List<Country> data;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: List<Country>.from(json["Data"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Country {
  Country({
    required this.id,
    required this.name,
    // required this.delete,
    // required this.createdAt,
    // required this.updatedAt,
    required this.city,
  });

  int id;
  String name;
  // int delete;
  // DateTime createdAt;
  // DateTime updatedAt;
  List<City> city;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    // delete: json["delete"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    city: List<City>.from(json["city"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    // "delete": delete,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
    "city": List<dynamic>.from(city.map((x) => x.toJson())),
  };
}

class City {
  City({
    required this.id,
    required this.name,
    required this.countryId,
    // required this.delete,
    // required this.createdAt,
    // required this.updatedAt,
    required this.region,
  });

  int id;
  String name;
  int countryId;
  // int delete;
  // DateTime createdAt;
  // DateTime updatedAt;
  List<Region> region;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
    // delete: json["delete"],
    // createdAt:  DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    region: List<Region>.from(json["region"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId,
    // "delete": delete,
    // "created_at":  createdAt.toIso8601String(),
    // "updated_at":  updatedAt.toIso8601String(),
    "region": List<dynamic>.from(region.map((x) => x.toJson())),
  };
}


class Region {
  Region({
    required this.id,
    required this.name,
    required this.countryId,
    // required this.delete,
    // required this.createdAt,
    // required this.updatedAt,
    required this.cityId,
  });

  int id;
  String name;
  int countryId;
  // int delete;
  // DateTime createdAt;
  // DateTime updatedAt;
  int cityId;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
    // delete: json["delete"],
    // createdAt:  DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    cityId: json["city_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId,
    // "delete": delete,
    // "created_at":  createdAt.toIso8601String(),
    // "updated_at":  updatedAt.toIso8601String(),
    "city_id":  cityId,
  };
}
