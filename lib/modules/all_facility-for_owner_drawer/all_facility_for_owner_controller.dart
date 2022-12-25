import 'package:business_01/modules/all_facility-for_owner_drawer/all_facility_for_owner_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/searsh_results.dart';

class AllFacilityForOwnerController  {
  late ScrollController FacilityOwnerController= ScrollController();
  late bool State = false;
  late String NextPageUrl = '';
  late var IsLoaded = false.obs;
  late var NumberOfFacilitiesInList = 0.obs;
  late List<SearchResult> FacilitiesList = [];
  late bool ArrivedToEndOfList = false;
  late SharedData sharedData = SharedData();
  late AllFacilityForOwnerServer allFacilityForOwnerServer = AllFacilityForOwnerServer();


    AllFacilityForOwnerController(){
      FacilityOwnerController.addListener(() {
        if (FacilityOwnerController.position.maxScrollExtent ==
            FacilityOwnerController.offset) {
          if (!ArrivedToEndOfList)
            GetNewFacilitiesForOwner();
        }
      });
    }



  void GetNewFacilitiesForOwner()async{
    String Token = await sharedData.GetToken();
    List<SearchResult> NewFacilities;
    NewFacilities = await allFacilityForOwnerServer.GetNewFacility(Token,NextPageUrl);
    State = allFacilityForOwnerServer.IsLoaded;
    if(State){
      print('ssdsds');
      IsLoaded(true);
      FacilitiesList.addAll(NewFacilities);
      NumberOfFacilitiesInList(FacilitiesList.length);
      NextPageUrl = allFacilityForOwnerServer.NextPageUrl;
      if(allFacilityForOwnerServer.CurrentPage == allFacilityForOwnerServer.LastPage)
        ArrivedToEndOfList = true;

    }
  }
}