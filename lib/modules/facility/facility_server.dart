import 'dart:convert';
import 'dart:io';

import 'package:business_01/models/facility_images_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/facility_info.dart';
import '../../models/facility_posts_pagination.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class FacilityServer {
  var GetFacilityInfoRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFacilityInfoURL);
  var GetFacilityImageRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFacilityImagesURL);
  var GetFacilityJobsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFacilityJobsURL);
  var GetFacilityOffersRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFacilityOffersURL);
  var SendFacilityJopRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddNewFacilityJopURL);
  var SendFacilityOfferRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddNewFacilityOfferURL);
  var SendEditFacilityJopRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.EditFacilityJopURL);
  var SendDeleteFacilityJopRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteFacilityJopURL);
  var SendEditFacilityOfferRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.EditFacilityOfferURL);
  var SendDeleteFacilityOfferRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteFacilityOfferURL);
  var SendFollowFoundationRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.FollowFacilityURL);
  var SendUnFollowFoundationRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.UnFollowFacilityURL);
  var AddChatWithFacilityRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddChatWithFacilityURL);

  String Message = '';
  bool State = false;
  bool Loaded = false;
  String NextPageUrl = "";
  int currentPage = 0;
  int lastPage = 0;

  Future<FacilityInformation> GetInformationOfFacility(String Token,
      int FacilityId,) async {
    FacilityInformation facilityInformation = FacilityInformation(
      id: 0,
      name: "",
      photo: "",
      countriesId: 0,
      citiesId: 0,
      regionsId: 0,
      locationX: "",
      locationY: "",
      description: "",
      follow:false,
      createdAt: DateTime.now(),
      country: Place(id: 0, name: ""),
      city: Place(id: 0, name: ""),
      region: Place(id: 0, name: ""),);
    // try {
      var jsonResponse = await http.post(GetFacilityInfoRoute, headers: {
        'Accept': 'application/json',
        'auth-token': '${Token}',
      }, body: {
        'id': '${FacilityId}',
      });
      if (jsonResponse.statusCode == 200) {
        FacilityInfo facilityInfo = facilityInfoFromJson(jsonResponse.body);
        print(facilityInfo.msg);
        if (facilityInfo.status == true) {
          facilityInformation = FacilityInformation(
            id: facilityInfo.data.id,
            name: facilityInfo.data.name,
            photo: facilityInfo.data.photo,
            countriesId: facilityInfo.data.countriesId,
            citiesId: facilityInfo.data.citiesId,
            regionsId: facilityInfo.data.regionsId,
            locationX: facilityInfo.data.locationX,
            locationY: facilityInfo.data.locationY,
            createdAt: facilityInfo.data.createdAt,
            description: facilityInfo.data.description,
            follow: facilityInfo.data.follow,
            country: facilityInfo.data.country,
            city: facilityInfo.data.city,
            region: facilityInfo.data.region,);
          Loaded = true;
          return facilityInfo.data;
        }
        return facilityInformation;
      }
      return facilityInformation;
    // } catch (e) {
    //   print(e);
    //   return facilityInformation;
    // }
  }

  Future<List<FacilityImage>> GetFacilityImages(String Token, int FacilityId,
      String NextPageUrl) async {
    var PageURL;

    Loaded = false;
    if (NextPageUrl == "")
      PageURL = GetFacilityImageRoute;
    else
      PageURL = Uri.parse(NextPageUrl);
    try {
      var jsonResponse = await http.post(
          PageURL,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}',
          },
          body: {
            'id': '${FacilityId}',
          }
      );
      print('object');
      if (jsonResponse.statusCode == 200) {
        FacilityPhotosPagination facilityPhotosPagination = facilityPhotosPaginationFromJson(
            jsonResponse.body);
        if (facilityPhotosPagination.status == true) {
          Loaded = true;
          NextPageUrl = (facilityPhotosPagination.data.nextPageUrl == null
              ? ""
              : facilityPhotosPagination.data.nextPageUrl)!;
          print(facilityPhotosPagination.data.currentPage);
          print(facilityPhotosPagination.data.lastPage);
          currentPage = facilityPhotosPagination.data.currentPage;
          lastPage = facilityPhotosPagination.data.lastPage;
          return facilityPhotosPagination.data.data;
        } else {
          Loaded = false;
          return [];
        }
      }
      Loaded = false;
      return [];
    } catch (e) {
      print(e);
      Loaded = false;
      return [];
    }
  }

  Future<List<PostInfo>> GetNewJobsPage(String Token, int FacilityId,
      String NextPageUrll) async {
    var PageURL;
    Loaded = false;
    if (NextPageUrll == "")
      PageURL = GetFacilityJobsRoute;
    else
      PageURL = Uri.parse(NextPageUrll);
    try{
      var jsonResponse = await http.post(
          PageURL,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'id': '${FacilityId}'
          }
      );
      if (jsonResponse.statusCode == 200) {
        var Response = facilityPostsPaginationFromJson(jsonResponse.body);
        if (Response.status == true) {
          Loaded = true;
          NextPageUrl =
          (Response.data.nextPageUrl == null ? "" : Response.data.nextPageUrl)!;
          currentPage = Response.data.currentPage;
          lastPage = Response.data.lastPage;
          return Response.data.data;
        }else{
          return [];
        }
      }
      else{
        return [];
      }
    }catch(e){
      print(e);
      return[];
    }
  }

  Future<List<PostInfo>> GetNewOffersPage (String Token , int FacilityID , String NextPageUrll )async{
    var PageURL;
    Loaded = false;
    if (NextPageUrll == "")
      PageURL = GetFacilityOffersRoute;
    else
      PageURL = Uri.parse(NextPageUrll);
    try{
      var jsonResponse = await http.post(
          PageURL,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'id': '${FacilityID}'
          }
      );
      if (jsonResponse.statusCode == 200) {
        var Response = facilityPostsPaginationFromJson(jsonResponse.body);
        if (Response.status == true) {
          Loaded = true;
          NextPageUrl = (Response.data.nextPageUrl == null ? "" : Response.data.nextPageUrl)!;
          currentPage = Response.data.currentPage;
          lastPage = Response.data.lastPage;
          return Response.data.data;
        }else{
          return [];
        }
      }
      else{
        return [];
      }
    }catch(e){
      print(e);
      return[];
    }
  }

  Future<bool> SendNewJop(BuildContext context, String Token, int FacilityId,
      String PostTitle, String PostDescritption, File? PostImage,
      File? PostVideo)async{
    try{
      var JsonResponse = http.MultipartRequest(
          'post', SendFacilityJopRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'foundation_id': "${FacilityId}",
        'title': "${PostTitle}",
        'description': '${PostDescritption}'
      });
      if (PostImage != null) {
        var SendPostImage = http.MultipartFile.fromBytes(
            'photo', PostImage.readAsBytesSync(),
            filename: PostImage.path);
        JsonResponse.files.add(SendPostImage);
      }
      if (PostVideo != null) {
        var SendPostVideo = http.MultipartFile.fromBytes(
            'video', PostVideo.readAsBytesSync(),
            filename: PostVideo.path);
        JsonResponse.files.add(SendPostVideo);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        Loaded = true;
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        return false;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool> SendEditingJop(BuildContext context, String Token,
      int EditingPostId, String PostTitle, String PostDescritption,
      File? PostImage, File? PostVideo) async {
    try {
      var JsonResponse = http.MultipartRequest('post', SendEditFacilityJopRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'id': "${EditingPostId}",
        'title': "${PostTitle}",
        'description': '${PostDescritption}'
      });

      if (PostImage != null) {
        var SendPostImage = http.MultipartFile.fromBytes(
            'photo', PostImage.readAsBytesSync(),
            filename: PostImage.path);
        JsonResponse.files.add(SendPostImage);
      }
      if (PostVideo != null) {
        var SendPostVideo = http.MultipartFile.fromBytes(
            'photo', PostVideo.readAsBytesSync(),
            filename: PostVideo.path);
        JsonResponse.files.add(SendPostVideo);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        Loaded = true;
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        return false;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    } catch (e) {
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }



  Future<bool> SendDeleteJop(BuildContext context, String Token,
      int PostId) async {
    try {
      var jsonResponse = await http.post(SendDeleteFacilityJopRoute,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'id':'${PostId}'
          });
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        return response['status'] ;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool> SendNewOffer(BuildContext context, String Token, int FacilityId,
      String PostTitle, String PostDescritption, File? PostImage,
      File? PostVideo)async{
    try{
      var JsonResponse = http.MultipartRequest(
          'post', SendFacilityOfferRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'foundation_id': "${FacilityId}",
        'title': "${PostTitle}",
        'description': '${PostDescritption}'
      });
      if (PostImage != null) {
        var SendPostImage = http.MultipartFile.fromBytes(
            'photo', PostImage.readAsBytesSync(),
            filename: PostImage.path);
        JsonResponse.files.add(SendPostImage);
      }
      if (PostVideo != null) {
        var SendPostVideo = http.MultipartFile.fromBytes(
            'video', PostVideo.readAsBytesSync(),
            filename: PostVideo.path);
        JsonResponse.files.add(SendPostVideo);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        Loaded = true;
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        return false;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool> SendEditingOffer(BuildContext context, String Token,
      int EditingPostId, String PostTitle, String PostDescritption,
      File? PostImage, File? PostVideo) async {
    try {
      var JsonResponse = http.MultipartRequest('post', SendEditFacilityOfferRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'id': "${EditingPostId}",
        'title': "${PostTitle}",
        'description': '${PostDescritption}'
      });

      if (PostImage != null) {
        var SendPostImage = http.MultipartFile.fromBytes(
            'photo', PostImage.readAsBytesSync(),
            filename: PostImage.path);
        JsonResponse.files.add(SendPostImage);
      }
      if (PostVideo != null) {
        var SendPostVideo = http.MultipartFile.fromBytes(
            'photo', PostVideo.readAsBytesSync(),
            filename: PostVideo.path);
        JsonResponse.files.add(SendPostVideo);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        Loaded = true;
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        return false;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    } catch (e) {
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool> SendDeleteOffer(BuildContext context, String Token,
      int PostId) async {
    try {
      var jsonResponse = await http.post(SendDeleteFacilityOfferRoute,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'id':'${PostId}'
          });
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        return response['status'] ;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool> SendFollowFacility(BuildContext context, String Token,
      int FacilityId) async {
    try {
      var jsonResponse = await http.post(SendFollowFoundationRoute,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'foundation_id':'${FacilityId}'
          });
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        return response['status'] ;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }


  Future<bool> SendUnFollowFacility(BuildContext context, String Token,
      int FacilityId) async {
    try {
      var jsonResponse = await http.post(SendUnFollowFoundationRoute,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'foundation_id':'${FacilityId}'
          });
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        return response['status'] ;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<int> GetChatIdToStartChat(BuildContext context, String Token,
      int FacilityId) async {
    try {
      var jsonResponse = await http.post(AddChatWithFacilityRoute,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'foundation_id':'${FacilityId}'
          });
      print(jsonResponse.statusCode);
    if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status']){
          return response['Data'];
        }
        else{
          Message = response['msg'];
          return -1;

        }
      }
      Message = AppLocalizations.of(context)!.connection_error;
      print(jsonResponse.body);
      return -1;
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return -1;
    }
  }
}

