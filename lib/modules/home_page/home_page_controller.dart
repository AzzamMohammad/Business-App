import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/facilitis_follow.dart';
import '../../models/posts_of_following_facility.dart';
import '../../storage/shared_data.dart';
import 'home_page_server.dart';

class HomePageController extends GetxController{
  late ScrollController FacilityPostsScrollController;
  late ScrollController FacilityFollowListScrollController;
  late CarouselController AdminPostsListScrollController;
  late HomePageServer homePageServer ;
  late String message;
  late bool State;
  late SharedData sharedData ;
  late String Token = '';
  late List<FacilityFollow> FacilityFollowList;
  late var NumberOfFacilityFollowList;
  late bool ArrivedToFacilityFollowListEnd;
  late String NextFacilityFollowPage;
  late List<FollowFacilityPost> FacilityPosts;
  late var NumberOfFacilityPostsList;
  late bool ArrivedToFacilityPostsListEnd;
  late String NextFacilityPostsPage;
  late var IsLoadFacilityFollowList;
  late List<FollowFacilityPost> AdminPostsList;
  late var NumberOfAdminPostsList;
  late bool ArrivedToAdminPostsListEnd;
  late String NextAdminPostsPage;
  late int CounterToGetEndOfPostList;


  @override
  void onInit()async {
    FacilityPostsScrollController = ScrollController();
    FacilityFollowListScrollController = ScrollController();
    AdminPostsListScrollController = CarouselController();
    homePageServer = HomePageServer();
    message = '';
    State = false;
    FacilityFollowList = [];
    NumberOfFacilityFollowList = 0.obs;
    ArrivedToFacilityFollowListEnd = false;
    NextFacilityFollowPage = '';
    FacilityPosts = [];
    NumberOfFacilityPostsList = 0.obs;
    ArrivedToFacilityPostsListEnd = false;
    NextFacilityPostsPage = '';
    IsLoadFacilityFollowList = false.obs;
    AdminPostsList = [];
    NumberOfAdminPostsList = 0.obs;
    ArrivedToAdminPostsListEnd = false;
    NextAdminPostsPage = '';
    CounterToGetEndOfPostList = 0;
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    FacilityFollowListScrollController.addListener(() {
      if(FacilityFollowListScrollController.position.maxScrollExtent == FacilityFollowListScrollController.offset){
        if(!ArrivedToFacilityFollowListEnd)
          GetNewFacilityFollowListItem();
      }
    });
    FacilityPostsScrollController.addListener(() {
      if(FacilityPostsScrollController.position.maxScrollExtent == FacilityPostsScrollController.offset){
        if(!ArrivedToFacilityPostsListEnd)
          GetNewFacilityPostsListItem();
      }
    });
    super.onInit();
  }
  @override
  void onReady(){
    GetNewFacilityFollowListItem();
    GetNewFacilityPostsListItem();
    GetNewAdminPostsListItem();
    super.onReady();
  }
  @override
  void dispose() {
    FacilityPostsScrollController.dispose();
    FacilityFollowListScrollController.dispose();
    super.dispose();
  }

  Future<void> GetNewFacilityFollowListItem()async{
    State = false;
    List<FacilityFollow> NewItem = [];
    while(!State){
      NewItem = await homePageServer.GetNewFacilityFollowItems(Token , NextFacilityFollowPage);
      State = homePageServer.IsLoaded;
    }
    IsLoadFacilityFollowList(true);
    FacilityFollowList.addAll(NewItem);
    NumberOfFacilityFollowList (FacilityFollowList.length) ;
    NextFacilityFollowPage = homePageServer.NextPageUrl;
    if(homePageServer.CurrentPageFollowFacility == homePageServer.LastPageFollowFacility)
      ArrivedToFacilityFollowListEnd = true;
  }

  Future<void> GetNewFacilityPostsListItem()async{
    State = false;
    List<FollowFacilityPost> NewItem = [];
    while(!State){

      NewItem = await homePageServer.GetNewFacilityPostsItems(Token , NextFacilityPostsPage);
      State = homePageServer.IsLoaded;
      print(State);
    }
    FacilityPosts.addAll(NewItem);
    NumberOfFacilityPostsList (FacilityPosts.length) ;
    NextFacilityPostsPage = homePageServer.NextPageUrl;
    if(homePageServer.CurrentPage == homePageServer.LastPage)
      ArrivedToFacilityPostsListEnd = true;
  }

  Future<void> GetNewAdminPostsListItem()async{
    State = false;
    List<FollowFacilityPost> NewItem = [];
    NewItem = await homePageServer.GetNewAdminPostsItems(Token , NextAdminPostsPage);
    State = homePageServer.IsLoaded;
    print(State);
    if(!State) {
      AdminPostsList.addAll(NewItem);
      NumberOfAdminPostsList(AdminPostsList.length);
      NextAdminPostsPage = homePageServer.NextPageUrl;
      if (homePageServer.CurrentPage == homePageServer.LastPage)
        ArrivedToAdminPostsListEnd = true;
    }
  }

  void RefreshPage(){
    NumberOfAdminPostsList(0);
    NextAdminPostsPage = "";
    AdminPostsList.clear();
    ArrivedToAdminPostsListEnd = false;
    NumberOfFacilityFollowList(0);
    NextFacilityFollowPage = '';
    FacilityFollowList.clear();
    IsLoadFacilityFollowList(false);
    ArrivedToFacilityFollowListEnd = false;
    NumberOfFacilityPostsList(0);
    NextFacilityPostsPage = '';
    FacilityPosts.clear();
    ArrivedToFacilityPostsListEnd = false;
    GetNewFacilityFollowListItem();
    GetNewFacilityPostsListItem();
    GetNewAdminPostsListItem();
  }
}