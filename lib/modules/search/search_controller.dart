import 'package:business_01/modules/search/search_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../models/Facility_filtering_types.dart';
import '../../models/searsh_results.dart';

class SearchController extends GetxController{
  late TextEditingController SearchFieldController;
  late ScrollController FacilitySearchScrollController;
  late var CountryId;
  late var CityId;
  late var TownId;
  late String TextSearching;
  late SharedData sharedData;
  late String Token;
  late String Message;
  late bool State;
  late var TypesISLoaded;
  late SearchServer searchServer;
  late List<FilteringTypes> filteringTypes;
  late var IndexOfSelectedType;
  late List<SearchResult> TotalSearchResultsList;
  late List<SearchResult> DisplaySearchResultsList;
  late String NextPageURL;
  late bool ArrivedToEndPage;
  late var IsLoading;
  late int NumberOfMemberInTotalList;
  late var NumberOfMemberInDisplayList;
  late var SelectedCountry;
  late var SelectedCity;
  late var SelectedTown;
  late String? SearchingText;
  late int? SearchingCountry;
  late int? SearchingCity;
  late int? SearchingTown;


 @override
  void onInit() async{

    Message = '';
   State = false;
   TypesISLoaded = false.obs;
   CountryId = 0.obs;
   CityId = 0.obs;
   TownId = 0.obs;
   TextSearching = '';
   IndexOfSelectedType = 0.obs;
   NumberOfMemberInDisplayList = 0.obs;
   NumberOfMemberInTotalList = 0;
   searchServer = SearchServer();
   filteringTypes = [];
   TotalSearchResultsList = [];
   DisplaySearchResultsList = [];
   NextPageURL = '';
   ArrivedToEndPage = false;
   IsLoading = false.obs;
   SelectedCountry = ''.obs;
   SelectedCity= ''.obs;
   SelectedTown = ''.obs;
   SearchFieldController = TextEditingController();
    SearchingCountry = null;
    SearchingText = null;
    SearchingCity = null;
    SearchingTown = null;
   sharedData = SharedData();
   Token = await sharedData.GetToken();
   FacilitySearchScrollController = ScrollController();

    FacilitySearchScrollController.addListener(() {
      if(FacilitySearchScrollController.position.maxScrollExtent== FacilitySearchScrollController.position.pixels){
        if(!ArrivedToEndPage){
          GetNewFacilitiesResults(SearchingText,SearchingCountry,SearchingCity,SearchingTown);
        }
      }
    });
    super.onInit();
  }

  @override
  void onReady()async {
    GetFilteringTypes();
    await GetNewFacilitiesResults(SearchingText,SearchingCountry,SearchingCity,SearchingTown);
    super.onReady();
  }

  @override
  void dispose() {
    FacilitySearchScrollController.dispose();
    SearchFieldController.dispose();
    super.dispose();
  }
  Future<void> GetFilteringTypes()async{
    FilteringTypes Type = FilteringTypes(id: -1, name: Get.locale?.languageCode == 'en' ?'all':'الكل');

    filteringTypes.add(Type);
    List<FilteringTypes> NewFilteringType;
    NewFilteringType = await searchServer.GetFacilityFilteringTypes(Token);
    filteringTypes.addAll(NewFilteringType);
   State = searchServer.State;
   if(State)
     TypesISLoaded(true);
  }


  Future<void> SearchForFacilities()async{
   TotalSearchResultsList.clear();
   NumberOfMemberInTotalList = 0;
   DisplaySearchResultsList.clear();
   NumberOfMemberInDisplayList(0);
   NextPageURL = '';
   ArrivedToEndPage = false;
   IsLoading(false);
   if (SearchFieldController.value.text != '')
     SearchingText = SearchFieldController.value.text;
   else
     SearchingText = null;
   if (SelectedCountry.value != '') {
     SearchingCountry = CountryList[CountryId.value].id;
   } else {
     SearchingCountry = null;
   }
   if (SelectedCity.value != '') {
     SearchingCity = CountryList[CountryId.value]
         .city[CityId.value]
         .id;
   } else {
     SearchingCity = null;
   }
   if (SelectedTown.value != '')
     SearchingTown = CountryList[CountryId.value]
         .city[CityId.value]
         .region[TownId.value]
         .id;
   else {
     SearchingTown = null;
   }
   await GetNewFacilitiesResults(SearchingText,SearchingCountry,SearchingCity,SearchingTown);
  }

  Future<void> GetNewFacilitiesResults( String? TextSearching ,int? CountryId,int? CityId , int? TownId)async {
    //for pagination : TextSearching = null
    State = false;
   List<SearchResult> NewSearchResultsList;
   NewSearchResultsList = await searchServer.GetNewSearchingResults(Token,TextSearching,NextPageURL,CountryId,CityId,TownId);
   if(searchServer.IsLoaded){
      IsLoading(true);
      State = true;
      print(NewSearchResultsList.length);
      TotalSearchResultsList.addAll(NewSearchResultsList);
     NumberOfMemberInTotalList = TotalSearchResultsList.length;
     AddNewItemsToDisplayList(NewSearchResultsList);
      NextPageURL = searchServer.NextPageUrl;
     if(searchServer.CurrentPage == searchServer.LastPage)
       ArrivedToEndPage = true;
   }

  }
  void AddNewItemsToDisplayList(List<SearchResult> NewSearchResultsList){
    NumberOfMemberInDisplayList(0);
    //Filtering type is not all
    if(filteringTypes[IndexOfSelectedType.value].id != -1){
      List<SearchResult> Help = NewSearchResultsList;
      NewSearchResultsList.clear();
      Help.forEach((element) {
        NewSearchResultsList.addAll(element.jobClass.where((type) => type.id == filteringTypes[IndexOfSelectedType.value].id ));
      });
      Help.clear();
    }
    DisplaySearchResultsList.addAll(NewSearchResultsList);
    NumberOfMemberInDisplayList(DisplaySearchResultsList.length);

  }

  void GetTheFacilitiesResult(){
    DisplaySearchResultsList.clear();
    NumberOfMemberInDisplayList(0);
    if(filteringTypes[IndexOfSelectedType.value].id != -1){
      List<SearchResult> Help = [];
      Help.addAll(TotalSearchResultsList);
      Help.forEach((element) {
        element.jobClass.forEach(
            (e){

              if(e.id == filteringTypes[IndexOfSelectedType.value].id){
                DisplaySearchResultsList.add(element);
              }
            }
        );
      });
      Help.clear();
    }
    else {
      DisplaySearchResultsList.addAll(TotalSearchResultsList);
    }
    NumberOfMemberInDisplayList(DisplaySearchResultsList.length);
    if(NumberOfMemberInDisplayList.value < 20 && !ArrivedToEndPage){
      print(SearchingText);
      GetNewFacilitiesResults(SearchingText,SearchingCountry,SearchingCity,SearchingTown);

    }
  }

  void Refresh(){
    DisplaySearchResultsList.clear();
    NextPageURL = '';
    ArrivedToEndPage = false;
    IsLoading(false);
    NumberOfMemberInDisplayList(0);
    GetNewFacilitiesResults(SearchingText,SearchingCountry,SearchingCity,SearchingTown);
  }

}