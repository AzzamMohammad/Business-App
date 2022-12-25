import 'dart:io';

import 'package:business_01/modules/facility/facility_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/facility_images_pagination.dart';
import '../../models/facility_info.dart';
import '../../models/facility_posts_pagination.dart';

class FacilityController extends GetxController{
  late ScrollController FacilityScrollController;//controller to offer ListView
  // late ScrollController scrollJobsController;//controller to jobs ListView
  late ScrollController scrollImageController;//controller to image GridView
  late FacilityServer facilityServer;
  late SharedData sharedData;
  late String Token;
  late var IsLoadedInfo ;// To refresh the interface after loading the data from server
  late var IsLoadedImage ;// To images bar the interface after loading the data from server
  late FacilityInformation facilityInformation ;// object from FacilityInformation class
  late bool State; // to check the state of response data
  late String NextImageFacilityPageURL;// the URL of next page in image facility pagenation
  late String NextJobsFacilityPageURL;// the URL of next page in image facility pagenation
  late String NextOffersFacilityPageURL;// the URL of next page in image facility pagenation
  late List<FacilityImage> FacilityImagesList; //List Of display Facility images
  late List<PostInfo> FacilityJobsList;//List Of display Facility Jobs
  late List<PostInfo> FacilityOffersList;
  late bool ArrivedToLastFacilityImagePage; // equal to true if arrived to last page in image pagination
  late bool ArrivedToLastFacilityJobsPage; // equal to true if arrived to last page in jobs pagination
  late bool ArrivedToLastFacilityOfferPage;
  late var NumberOfListJobsItems;// to refresh listview jobs
  late var NumberOfListOffersItem;//
  late bool UserFollowTheFoundation;
  late bool IsUser;
  late int FacilityId;
  late var selectJobs ;
  late int ChatWithFoundationId;

  late String PostTitle;
  late String PostDescription;
  late File? PostImageFile;
  late File? PostVideoFile;
  late int PostId ;
  late String Message;


  @override
  void onInit() async{
    FacilityScrollController = ScrollController();
    scrollImageController = ScrollController();
    facilityServer = FacilityServer();
    FacilityImagesList = [];
    FacilityJobsList = [];
    ArrivedToLastFacilityImagePage = false;
    sharedData = SharedData();
    IsLoadedInfo = false.obs;
    IsLoadedImage = false.obs;
    selectJobs = true.obs;
    State = false;
    ChatWithFoundationId = -1;
    UserFollowTheFoundation = false;
    NextImageFacilityPageURL ="";
    NextJobsFacilityPageURL = "";
    ArrivedToLastFacilityJobsPage = false;
    NumberOfListJobsItems = 0.obs;
    NextOffersFacilityPageURL = '';
    FacilityOffersList = [];
    ArrivedToLastFacilityOfferPage = false;
    NumberOfListOffersItem = 0.obs;
    PostTitle = '';
    PostDescription = '';
    PostImageFile = null;
    PostVideoFile = null;
    PostId = 0;
    Message = '';
    IsUser = Get.arguments['is_user'];
    FacilityId = Get.arguments['facility_id'];
    Token = await sharedData.GetToken();
    FacilityScrollController.addListener(() {
      if(FacilityScrollController.position.maxScrollExtent == FacilityScrollController.offset){
        if(selectJobs.value){
          if(!ArrivedToLastFacilityJobsPage)
            GetMoreJobsToList();
        }else{
          if(!ArrivedToLastFacilityOfferPage)
            GetNewOffer();
        }

      }
    });
    super.onInit();
  }

  @override
  void onReady() async{
     await GetFacilityInfo();
     await GetLastFacilityImagePage();
    // GetMoreJobsToList();
    super.onReady();
  }


  @override
  void dispose() {
    FacilityScrollController.dispose();
    scrollImageController.dispose();
    super.dispose();
  }

  Future<void> GetFacilityInfo()async{
    State = false;
    while(State == false){
      facilityInformation = await facilityServer.GetInformationOfFacility(Token, FacilityId);
     State = facilityServer.Loaded;
      UserFollowTheFoundation = facilityInformation.follow;

    }
  }

  Future<void> GetLastFacilityImagePage()async{
    State = false;
    List<FacilityImage> NewFacilityImages=[];
    if(ArrivedToLastFacilityImagePage != true){
      while(State == false){
        NewFacilityImages = await facilityServer.GetFacilityImages(Token,facilityInformation.id , NextImageFacilityPageURL);
        State =facilityServer.Loaded;
      }
      FacilityImagesList.addAll(NewFacilityImages);
      IsLoadedImage(true);
      NextImageFacilityPageURL = facilityServer.NextPageUrl;
      if(facilityServer.currentPage == facilityServer.lastPage)
        ArrivedToLastFacilityImagePage = true;
      IsLoadedInfo(true);
    }
  }

  void GetMoreJobsToList()async{
    State = false;
    List<PostInfo> NewJobsInfoList = [];
    while(!State){
      NewJobsInfoList = await facilityServer.GetNewJobsPage(Token , facilityInformation.id  ,NextJobsFacilityPageURL);
      State = facilityServer.Loaded;
    }
    FacilityJobsList.addAll(NewJobsInfoList);
    NumberOfListJobsItems(FacilityJobsList.length);
    NextJobsFacilityPageURL = facilityServer.NextPageUrl;
    if(facilityServer.currentPage == facilityServer.lastPage)
      ArrivedToLastFacilityJobsPage= true;
  }

  Future<void> GetNewOffer()async {
    State = false;
    List<PostInfo> NewOffersInfoList = [];
    while(!State){
      NewOffersInfoList = await facilityServer.GetNewOffersPage(Token , facilityInformation.id  ,NextOffersFacilityPageURL);
      State = facilityServer.Loaded;
    }
    FacilityOffersList.addAll(NewOffersInfoList);
    NumberOfListOffersItem(FacilityOffersList.length);
    NextOffersFacilityPageURL = facilityServer.NextPageUrl;
    if(facilityServer.currentPage == facilityServer.lastPage)
      ArrivedToLastFacilityOfferPage= true;
  }

  Future<void> AddTheNewJop(BuildContext context)async{
    State = await facilityServer.SendNewJop(context,Token , facilityInformation.id , PostTitle , PostDescription , PostImageFile , PostVideoFile);
    Message = facilityServer.Message;
  }
  Future <void> SendEditJopPost(BuildContext context)async{
    State = await facilityServer.SendEditingJop(context ,Token , PostId ,PostTitle , PostDescription , PostImageFile , PostVideoFile);
    Message = facilityServer.Message;
  }
  Future <void> SendDeleteJop(BuildContext context)async{
    State = await facilityServer.SendDeleteJop(context ,Token , PostId );
    Message = facilityServer.Message;
  }

  Future<void> AddTheNewOffer(BuildContext context)async{
    State = await facilityServer.SendNewOffer(context,Token , facilityInformation.id , PostTitle , PostDescription , PostImageFile , PostVideoFile);
    Message = facilityServer.Message;
  }

  Future <void> SendEditOfferPost(BuildContext context)async{
    State = await facilityServer.SendEditingOffer(context ,Token , PostId ,PostTitle , PostDescription , PostImageFile , PostVideoFile);
    Message = facilityServer.Message;
  }

  Future <void> SendDeleteOffer(BuildContext context)async{
    State = await facilityServer.SendDeleteOffer(context ,Token , PostId );
    Message = facilityServer.Message;
  }

  Future<void> FollowTheFoundation(BuildContext context)async{
    State = await facilityServer.SendFollowFacility(context ,Token , facilityInformation.id );
    Message = facilityServer.Message;
  }

  Future<void> UnFollowTheFoundation(BuildContext context)async{
    State = await facilityServer.SendUnFollowFacility(context ,Token , facilityInformation.id );
    Message = facilityServer.Message;
  }

  Future<void> StartChating(BuildContext context)async{
    ChatWithFoundationId = await facilityServer.GetChatIdToStartChat(context ,Token , facilityInformation.id );
    if(ChatWithFoundationId == -1)
      State = false;
    else
      State = true;
    Message = facilityServer.Message;
  }


  Future<void> RefreshScreen()async{
    IsLoadedInfo(false);
    IsLoadedImage(false);
    NextImageFacilityPageURL = '';
    FacilityImagesList.clear();
    ArrivedToLastFacilityImagePage = false;
    NextJobsFacilityPageURL = '';
    FacilityJobsList.clear();
    ArrivedToLastFacilityJobsPage = false;
    NumberOfListJobsItems(0);
    NextOffersFacilityPageURL = '';
    FacilityOffersList.clear();
    ArrivedToLastFacilityOfferPage = false;
    NumberOfListOffersItem(0);
    await GetFacilityInfo();
    await GetLastFacilityImagePage();
    GetMoreJobsToList();
    GetNewOffer();
  }


}