import 'dart:io';

import 'package:business_01/modules/facility_members/facility_member_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/facility_members.dart';

class FacilityMemberController extends GetxController{
  late ScrollController MemberListController;
  late List<Member> FacilityMember;
  late String Message;
  late bool State;
  late var IsLoaded;
  late var NumberOfMembersInList;
  late String NextPageURL;
  late FacilityMemberServer facilityMemberServer;
  late String Token;
  late SharedData sharedData;
  late bool ArrivedToEndOfListMember;
  late int FacilityId;
  late bool IsUser ;
  late String MemberName;
  late String MemberDescription;
  late File? MemberImage;
  late int MemberId;


  @override
  void onInit()async {
    IsUser = Get.arguments['is_user'];
    FacilityId = Get.arguments['facility_id'];
    MemberListController = ScrollController();
    FacilityMember = [];
    Message = '';
    State = false;
    IsLoaded = false.obs;
    NumberOfMembersInList = 0.obs;
    NextPageURL = "";
    facilityMemberServer = FacilityMemberServer();
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    ArrivedToEndOfListMember = false;
    MemberId = 0;
    MemberName = '';
    MemberDescription = '';
    MemberImage = null;
    MemberListController.addListener(() {
      if(MemberListController.position.maxScrollExtent == MemberListController.offset){
        if(!ArrivedToEndOfListMember)
          GetNewMember();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    if(!ArrivedToEndOfListMember)
      GetNewMember();
    super.onReady();
  }

  @override
  void dispose() {
    MemberListController.dispose();
    super.dispose();
  }

  void GetNewMember()async{
    State = false;
    List<Member> NewMember = [];
    if(!ArrivedToEndOfListMember){
      while(State != true){
        NewMember = await facilityMemberServer.GetMembers(Token , NextPageURL , FacilityId);
        State = facilityMemberServer.IsLoaded;
      }
      FacilityMember.addAll(NewMember);
      IsLoaded(true);
      print(FacilityMember.length);
      NextPageURL = facilityMemberServer.NextUrl;
      NumberOfMembersInList(FacilityMember.length);
      if(facilityMemberServer.CurrentPage == facilityMemberServer.LastPage)
        ArrivedToEndOfListMember = true;
    }

  }

  Future<void> SendNewMember(BuildContext context)async{
    State = await facilityMemberServer.SendTheMemberDetiles(context,Token , MemberName , MemberDescription , MemberImage , FacilityId);
    Message = facilityMemberServer.Message;
  }


  Future<void> SendEditMember(BuildContext context)async{
    State = await facilityMemberServer.SendEditMemberDetiles(context,Token , MemberName , MemberDescription , MemberImage , MemberId );
    Message = facilityMemberServer.Message;
  }

  Future<void> SendDeletePost(BuildContext context)async{
    State = await facilityMemberServer.SendDeleteMember(context,Token , MemberId);
    Message = facilityMemberServer.Message;
  }



  void RefreshMemberList(){
    IsLoaded(false);
    NumberOfMembersInList(0);
    NextPageURL = "";
    FacilityMember.clear();
    ArrivedToEndOfListMember = false;
    GetNewMember();
  }



}