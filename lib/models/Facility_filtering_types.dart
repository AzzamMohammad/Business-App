import 'dart:convert';

FacilityFilteringTypes facilityFilteringTypesFromJson(String str) => FacilityFilteringTypes.fromJson(json.decode(str));

String facilityFilteringTypesToJson(FacilityFilteringTypes data) => json.encode(data.toJson());

class FacilityFilteringTypes {
  FacilityFilteringTypes({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  dynamic data;

  factory FacilityFilteringTypes.fromJson(Map<String, dynamic> json) => FacilityFilteringTypes(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: json["Data"] != null? List<FilteringTypes>.from(json["Data"].map((x) => FilteringTypes.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class FilteringTypes {
  FilteringTypes({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory FilteringTypes.fromJson(Map<String, dynamic> json) => FilteringTypes(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
