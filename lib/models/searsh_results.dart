import 'dart:convert';

SearchResults searchResultsFromJson(String str) => SearchResults.fromJson(json.decode(str));

String searchResultsToJson(SearchResults data) => json.encode(data.toJson());

class SearchResults {
  SearchResults({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  var errNum;
  String msg;
  dynamic data;

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:json["Data"]!= null ? Data.fromJson(json["Data"]):[],
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
    data:json["data"]!=null? List<SearchResult>.from(json["data"].map((x) => SearchResult.fromJson(x))):[],
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

class SearchResult {
  SearchResult({
    required this.id,
    required this.name,
    required this.photo,
    required this.countriesId,
    required this.citiesId,
    required this.regionsId,
    required this.description,
    required this.jobClass,

  });

  int id;
  String name;
  String photo;
  dynamic countriesId;
  dynamic citiesId;
  dynamic regionsId;
  dynamic description;
  dynamic jobClass;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
    countriesId: json["countries_id"],
    citiesId: json["cities_id"],
    regionsId: json["regions_id"],
    description: json["description"],
    jobClass:json["job_class"] != null ? List<JobClass>.from(json["job_class"].map((x) => JobClass.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
    "countries_id": countriesId,
    "cities_id": citiesId,
    "regions_id": regionsId,
    "description": description,
    "job_class": List<dynamic>.from(jobClass.map((x) => x.toJson())),
  };
}

class JobClass {
  JobClass({
    required this.id,
    required this.foundationId,
    required this.jobClassId,
  });

  int id;
  int foundationId;
  int jobClassId;

  factory JobClass.fromJson(Map<String, dynamic> json) => JobClass(
    id: json["id"],
    foundationId: json["foundation_id"],
    jobClassId: json["jobClass_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "foundation_id": foundationId,
    "jobClass_id": jobClassId,
  };
}