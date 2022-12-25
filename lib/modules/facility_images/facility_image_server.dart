import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../config/server_config.dart';
import '../../models/facility_posts_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class FacilityImageServer {
  String Message = '';
  bool Loaded = false;
  String NextPageUrl = "";
  int currentPage = 0;
  int lastPage = 0;

  var GetFacilityImagesRoute = Uri.parse(
      ServerConfig.ServerDomain + ServerConfig.GetFacilityImagesListURL);
  var AddNewFacilityImageRoute = Uri.parse(
      ServerConfig.ServerDomain + ServerConfig.AddNewFacilityImageURL);
  var EditFacilityImageRoute = Uri.parse(
      ServerConfig.ServerDomain + ServerConfig.EditFacilityImageURL);
  var DeleteFacilityImageRoute = Uri.parse(
      ServerConfig.ServerDomain + ServerConfig.DeleteFacilityImageURL);


  Future<List<PostInfo>> GetNewImagesPage(String Token, int FacilityID,
      String NextPageUrll) async {
    var PageURL;
    Loaded = false;
    if (NextPageUrll == "")
      PageURL = GetFacilityImagesRoute;
    else
      PageURL = Uri.parse(NextPageUrll);
    try {
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
          NextPageUrl =
          (Response.data.nextPageUrl == null ? "" : Response.data.nextPageUrl)!;
          currentPage = Response.data.currentPage;
          lastPage = Response.data.lastPage;
          return Response.data.data;
        } else {
          return [];
        }
      }
      else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> SendNewImage(BuildContext context, String Token, int FacilityId,
      String PostTitle, String PostDescritption, File? PostImage,
      File? PostVideo) async {
    try {
      var JsonResponse = http.MultipartRequest(
          'post', AddNewFacilityImageRoute);
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
    } catch (e) {
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }

  Future<bool> SendEditingImage(BuildContext context, String Token,
      int EditingPostId, String PostTitle, String PostDescritption,
      File? PostImage, File? PostVideo) async {
    try {
      var JsonResponse = http.MultipartRequest('post', EditFacilityImageRoute);
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


  Future<bool> SendDelete(BuildContext context, String Token,
      int PostId) async {
    try {
      var jsonResponse = await http.post(DeleteFacilityImageRoute,
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
}