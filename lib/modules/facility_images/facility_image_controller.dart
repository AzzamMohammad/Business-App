
import 'dart:io';

import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../models/facility_posts_pagination.dart';
import 'facility_image_server.dart';

class FacilityImageController extends GetxController{
  late ScrollController scrollImageController= ScrollController();
  late List<PostInfo> FacilityImagesList;
  late var NumberOfListImagesItems;
  late String NextImagesFacilityPageURL;
  late bool ArrivedToLastFacilityImagesPage;
  late bool State;
  late String Message;
  late FacilityImageServer facilityImageServer;
  late String Token;
  late SharedData sharedData;
  late String FacilityImage;
  late String FacilityName;
  late String PostTitle;
  late String PostDescription;
  late File? PostImageFile;
  late File? PostVideoFile;
  late int PostId ;
  late int FacilityId;
  late bool IsUser;


  @override
  void onInit()async{
    FacilityImagesList = [];
    NumberOfListImagesItems = 0.obs;
    State = false;
    NextImagesFacilityPageURL = "";
    ArrivedToLastFacilityImagesPage = false;
    sharedData = SharedData();
    Message = '';
    PostId = 0;
    FacilityId = Get.arguments['facility_id'];
    IsUser = Get.arguments['IsUser'];

    facilityImageServer = FacilityImageServer();
    scrollImageController = ScrollController();
    FacilityName = Get.arguments['facility_name'];
    FacilityImage = Get.arguments['facility_image'];
    PostTitle = '';
    PostDescription = '';
    PostImageFile = null;
    PostVideoFile = null;
    Token = await sharedData.GetToken();
    scrollImageController.addListener(() {
      if(scrollImageController.position.maxScrollExtent == scrollImageController.offset){
        if(!ArrivedToLastFacilityImagesPage)
          GetNewFacilityImagesListItem();
      }
    });
    super.onInit();
  }
  @override
  void onReady() {
    GetNewFacilityImagesListItem();
    super.onReady();
  }

  @override
  void dispose() {
    scrollImageController.dispose();
    super.dispose();
  }

  void GetNewFacilityImagesListItem()async{
    State = false;
    List<PostInfo> NewImagesInfoList = [];
    while(!State){
      NewImagesInfoList = await facilityImageServer.GetNewImagesPage(Token , FacilityId ,NextImagesFacilityPageURL);
      State = facilityImageServer.Loaded;
    }
    FacilityImagesList.addAll(NewImagesInfoList);
    NumberOfListImagesItems(FacilityImagesList.length);
    NextImagesFacilityPageURL = facilityImageServer.NextPageUrl;
    if(facilityImageServer.currentPage == facilityImageServer.lastPage)
      ArrivedToLastFacilityImagesPage= true;
  }

  Future <void> SendNewImagePost (BuildContext context) async{
      State = await facilityImageServer.SendNewImage(context ,Token , FacilityId ,PostTitle , PostDescription , PostImageFile , PostVideoFile);
      Message = facilityImageServer.Message;
    }

    Future <void> SendEditImagePost(BuildContext context)async{
      State = await facilityImageServer.SendEditingImage(context ,Token , PostId ,PostTitle , PostDescription , PostImageFile , PostVideoFile);
      Message = facilityImageServer.Message;
    }

    Future <void> SendDeletePost(BuildContext context)async{
      State = await facilityImageServer.SendDelete(context ,Token , PostId );
      Message = facilityImageServer.Message;
    }

    void RefreshImageScreen (){
      FacilityImagesList.clear();
      ArrivedToLastFacilityImagesPage = false;
      NumberOfListImagesItems(0);
      NextImagesFacilityPageURL = '';
      GetNewFacilityImagesListItem();
    }


  }

