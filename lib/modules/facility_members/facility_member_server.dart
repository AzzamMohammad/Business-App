import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/facility_members.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class FacilityMemberServer {
  String Message = '';
  late bool IsLoaded ;
  String NextUrl = '';
  int LastPage = 0;
  int CurrentPage = 0;
  var GetFacilityMembersRoute =
      Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFacilityMembersURL);
  var AddNewFacilityMemberRoute =
      Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddNewFacilityMemberUrl);
  var EditFacilityMemberRoute =
      Uri.parse(ServerConfig.ServerDomain + ServerConfig.EditFacilityMemberUrl);
  var DeleteFacilityMemberRoute =
      Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteFacilityMemberUrl);
  Future<List<Member>> GetMembers(
      String Token, String NextPageUrl, int FacilityId) async {
    var PageURL;
    IsLoaded = false;
    if (NextPageUrl == "")
      PageURL = GetFacilityMembersRoute;
    else
      PageURL = Uri.parse(NextPageUrl);

    try {
      var jsonResponse = await http.post(PageURL,
          headers: {'auth-token': '${Token}','Accept': 'application/json',}, body: {'id': '${FacilityId}'});
      if (jsonResponse.statusCode == 200) {
        FacilityMembers response = facilityMembersFromJson(jsonResponse.body);
        print(response.msg);
        if (response.status == true) {
          IsLoaded = true;
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          if(response.data.nextPageUrl == null)
            NextUrl = "";
          else
            NextUrl = response.data.nextPageUrl;

          return response.data.data;
        } else {
          IsLoaded = false;
          return [];
        }
      } else {
        IsLoaded = false;
        return [];
      }
    } catch (e) {
      print(e);
      IsLoaded = false;
      return [];
    }
  }

  Future<bool> SendTheMemberDetiles(BuildContext context , String Token , String MemberName , String MemberDescription , File? MemberImage , int FacilityId)async{
    try{
      var JsonResponse = http.MultipartRequest(
          'post', AddNewFacilityMemberRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'name': "${MemberName}",
        'description': "${MemberDescription}",
        'foundation_id': "${FacilityId}",
      });
      if (MemberImage != null) {
        var SendMemberImage = http.MultipartFile.fromBytes(
            'photo', MemberImage.readAsBytesSync(),
            filename: MemberImage.path);
        JsonResponse.files.add(SendMemberImage);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        return false;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }


  Future<bool> SendEditMemberDetiles(BuildContext context , String Token , String MemberName , String MemberDescription , File? MemberImage , int MemberId )async{
    try{
      print(MemberId);
      print('lllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
      var JsonResponse = http.MultipartRequest(
          'post', EditFacilityMemberRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'name': "${MemberName}",
        'description': "${MemberDescription}",
        'id': "${MemberId}",
      });
      if (MemberImage != null) {
        var SendMemberImage = http.MultipartFile.fromBytes(
            'photo', MemberImage.readAsBytesSync(),
            filename: MemberImage.path);
        JsonResponse.files.add(SendMemberImage);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        return false;
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }catch(e){
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }


  Future<bool> SendDeleteMember(BuildContext context, String Token,
      int MemberId) async {
    try {

      var jsonResponse = await http.post(DeleteFacilityMemberRoute,
          headers: {
            'Accept': 'application/json',
            'auth-token': '${Token}'
          },
          body: {
            'id':'${MemberId}'
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
