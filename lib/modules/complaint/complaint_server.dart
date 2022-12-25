import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';

class ComplaintServer{
  String Message = '';
  var ComplaintRoute = Uri.parse(
      ServerConfig.ServerDomain + ServerConfig.ComplaintURL);

  Future<bool> SendComplaint(BuildContext context, String Token,String Complaint, File? ComplaintFile, String? Title,
      String? description) async {
    try {
      var JsonResponse = http.MultipartRequest(
          'post', ComplaintRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'text': "${Complaint}",
        'documents_title': "${Title}",
        'documents_description': '${description}'
      });
      if (ComplaintFile != null) {
        var SendComplaintFile = http.MultipartFile.fromBytes(
            'documents_pdf', ComplaintFile.readAsBytesSync(),
            filename: ComplaintFile.path);
        JsonResponse.files.add(SendComplaintFile);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        else{
          return false;
        }
      }
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    } catch (e) {
      print(e);
      Message = AppLocalizations.of(context)!.connection_error;
      return false;
    }
  }
}