import 'package:business_01/components/my_divider.dart';
import 'package:business_01/constants.dart';
import 'package:business_01/modules/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../components/bottom_bar.dart';
import '../../components/cach_image_from_network.dart';
import '../../components/loading/loading_members.dart';
import '../../components/loading/loding_message.dart';
import '../../components/setting_drawer.dart';
import '../../models/location.dart';
import '../all_facility-for_owner_drawer/all_facility_for_owner_drawer.dart';

class SearchScreen extends StatelessWidget {
  SearchController searchController = Get.find();
  var IsClicked = false.obs;
  String? SelectedCountryValue;
  String? SelectedCityValue;
  String? SelectedTownValue;
  final CityFieldIsAvailable = true.obs;
  final TownFieldIsAvailable = true.obs;
  final RefreshCountry = false.obs;
  final RefreshCity = false.obs;
  final RefreshTown = false.obs;
  LoadingMessage loadingMessage = LoadingMessage();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(_scaffoldKey.currentState!.isDrawerOpen){
          _scaffoldKey.currentState!.closeDrawer();

          return false;
        }

        if(_scaffoldKey.currentState!.isEndDrawerOpen){
          _scaffoldKey.currentState!.closeEndDrawer();
          return false;
        }

        if(searchController.FacilitySearchScrollController.position.pixels != 0){
          searchController.FacilitySearchScrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          return false;
        }
        Get.offAllNamed('/home_page');
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: BuildAllFacilityForOwner(context),
        endDrawer: BuildSettingDrawer(context),
        appBar: AppBar(
          /* An empty action for remove hamburger icon from */
          actions: [
            Container()
          ],
          automaticallyImplyLeading: false,
          title: Text('${AppLocalizations.of(context)!.search}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        body: SafeArea(child: Obx(() {
          return Column(
            children: [
              BuildSearchBar(context),
              searchController.TypesISLoaded.value
                  ? BuildTypesList(context)
                  : Container(),
              MyDivider(context, 1),
              BuildFacilityResultList(context),
            ],
          );
        })),
        bottomNavigationBar: BuildBottomBar(context, 3,_scaffoldKey),
      ),
    );
  }

  Widget BuildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PopupMenuButton<Widget>(
              position: PopupMenuPosition.over,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width ,
                minWidth: MediaQuery.of(context).size.width ,
              ),
              color: Theme.of(context).colorScheme == ColorScheme.light()
                  ? Color(0xffefefef)
                  : Color(0xff1a1a1a),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Icon(
                Icons.menu,
                size: 38,
                color: Color(0xff076579),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Obx(() {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          menuMaxHeight: 150,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          alignment: AlignmentDirectional.centerStart,
                          dropdownColor: Theme.of(context).colorScheme ==
                                  ColorScheme.light()
                              ? Color(0xfff1f1f1)
                              : Color(0xff252525),
                          items: CountryList.map((Country country) {
                            return DropdownMenuItem(
                                value: country.name,
                                child: Text(
                                  country.name,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                  fontSize: 14,),
                                  maxLines: 1,
                                ));
                          }).toList(),

                          hint: Text(
                            '${AppLocalizations.of(context)!.country}',
                            style: TextStyle(overflow: TextOverflow.ellipsis,
                              fontSize: 14,),
                            maxLines: 1,
                          ),
                          isExpanded: RefreshCountry.value
                              ? RefreshCountry.value
                              : true,
                          // underline: Divider(thickness: 2,color: Color(0xff076579),height: 20,),
                          icon: Icon(Icons.arrow_drop_down_outlined),
                          value: SelectedCountryValue,

                          onChanged: (value) {
                            RefreshCountry(!RefreshCountry.value);
                            searchController.SelectedCountry(value.toString());
                            searchController.CountryId(CountryList.indexWhere(
                                (country) => country.name == value));
                            searchController.CityId(0);
                            searchController.TownId(0);
                            if (CountryList[searchController.CountryId.value]
                                .city
                                .isEmpty) {
                              if (CityFieldIsAvailable.value == true)
                                Navigator.of(context).pop();
                              CityFieldIsAvailable(false);
                            } else if (CountryList[
                                    searchController.CountryId.value]
                                .city[0]
                                .region
                                .isEmpty) {
                              if (TownFieldIsAvailable.value == true)
                                Navigator.of(context).pop();
                              TownFieldIsAvailable(false);
                            } else {
                              if (CityFieldIsAvailable.value == false ||
                                  TownFieldIsAvailable.value == false)
                                Navigator.of(context).pop();
                              CityFieldIsAvailable(true);
                              TownFieldIsAvailable(true);
                            }
                            SelectedCityValue = null;
                            searchController.SelectedCity('');
                            SelectedTownValue = null;
                            searchController.SelectedTown('');
                            SelectedCountryValue =
                                searchController.SelectedCountry.value;
                          },
                        ),
                      );
                    }),
                  ),
                  CityFieldIsAvailable.value
                      ? PopupMenuItem(
                          child: Obx(() {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                menuMaxHeight: 150,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                alignment: AlignmentDirectional.centerStart,
                                dropdownColor: Theme.of(context).colorScheme ==
                                        ColorScheme.light()
                                    ? Color(0xfff1f1f1)
                                    : Color(0xff252525),

                                items: CountryList[
                                        searchController.CountryId.value]
                                    .city
                                    .map((City city) {
                                  return DropdownMenuItem(
                                    value: city.name,
                                    child: Text(
                                      city.name,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        fontSize: 14,),
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),

                                hint: Text(
                                  '${AppLocalizations.of(context)!.city}',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    fontSize: 14,),
                                  maxLines: 1,
                                ),
                                isExpanded: RefreshCity.value
                                    ? RefreshCity.value
                                    : true,
                                // underline: Divider(thickness: 2,color: Color(0xff076579),height: 20,),
                                icon: Icon(Icons.arrow_drop_down_outlined),
                                value: SelectedCityValue,
                                isDense:
                                    searchController.SelectedCountry.value == ''
                                        ? false
                                        : true,
                                onChanged: (value) {
                                  RefreshCity(!RefreshCity.value);
                                  searchController.SelectedCity(
                                      value.toString());
                                  searchController.CityId(CountryList[
                                          searchController.CountryId.value]
                                      .city
                                      .indexWhere(
                                          (city) => city.name == value));
                                  searchController.TownId(0);
                                  if (CountryList[
                                          searchController.CountryId.value]
                                      .city[searchController.CityId.value]
                                      .region
                                      .isEmpty) {
                                    if (TownFieldIsAvailable.value == true)
                                      Navigator.of(context).pop();
                                    TownFieldIsAvailable(false);
                                  } else {
                                    if (TownFieldIsAvailable.value == false)
                                      Navigator.of(context).pop();
                                    TownFieldIsAvailable(true);
                                  }
                                  SelectedTownValue = null;
                                  searchController.SelectedTown('');
                                  SelectedCityValue =
                                      searchController.SelectedCity.value;
                                },
                              ),
                            );
                          }),
                        )
                      : PopupMenuItem(child: null),
                  TownFieldIsAvailable.value && CityFieldIsAvailable.value
                      ? PopupMenuItem(
                          child: Obx(() {
                            List<City> reg =
                                CountryList[searchController.CountryId.value]
                                    .city;
                            if (!reg.isEmpty)
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  menuMaxHeight: 150,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  alignment: AlignmentDirectional.centerStart,
                                  dropdownColor:
                                      Theme.of(context).colorScheme ==
                                              ColorScheme.light()
                                          ? Color(0xfff1f1f1)
                                          : Color(0xff252525),
                                  isDense:
                                      searchController.SelectedCity.value == ''
                                          ? false
                                          : true,
                                  items: reg[searchController.CityId.value]
                                      .region
                                      .map((Region region) {
                                    return DropdownMenuItem(
                                      value: region.name,
                                      child: Text(
                                        region.name,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                          fontSize: 14,),
                                        maxLines: 1,
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    '${AppLocalizations.of(context)!.town}',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                      fontSize: 14,),
                                    maxLines: 1,
                                  ),
                                  isExpanded: RefreshTown.value
                                      ? RefreshTown.value
                                      : true,
                                  underline: Divider(thickness: 2,color: Color(0xff076579),height: 20,),
                                  icon: Icon(Icons.arrow_drop_down_outlined),
                                  value: SelectedTownValue,
                                  onChanged: (value) {
                                    RefreshTown(!RefreshTown.value);
                                    searchController.SelectedTown(
                                        value.toString());
                                    searchController.TownId(CountryList[
                                            searchController.CountryId.value]
                                        .city[searchController.CityId.value]
                                        .region
                                        .indexWhere(
                                            (town) => town.name == value));
                                    SelectedTownValue =
                                        searchController.SelectedTown.value;
                                  },
                                ),
                              );
                            return Container();
                          }),
                        )
                      : PopupMenuItem(child: null),
                  PopupMenuItem(
                       enabled: false,
                      child: Obx(() {
                    return GestureDetector(

                      onTapDown: (v) {
                        ResetLocation();
                        IsClicked(true);
                      },
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 200));
                        IsClicked(false);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, top: 5, right: 8, bottom: 5),
                              width: MediaQuery.of(context).size.width * .2,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Color(0xff076579)),
                                  color: Theme.of(context).colorScheme ==
                                          ColorScheme.light()
                                      ? Color(0xfff1f1f1)
                                      : Color(0xff252525),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    !IsClicked.value
                                        ? BoxShadow(
                                            color: Color(0xff076579),
                                            offset: rtlLanguages.contains(Get.locale?.languageCode)?Offset(3, 3):Offset(-3, 3),
                                            blurRadius: 3)
                                        : BoxShadow(
                                            color: Color(0xff076579),
                                            blurRadius: 2),
                                  ]),
                              child: Row(
                                children: [
                                  // Text('reset Information',style: TextStyle(color:Theme.of(context).colorScheme == ColorScheme.light()?Colors.black: Color(0xffececec),fontWeight: FontWeight.bold),),
                                  Icon(
                                    Icons.refresh,
                                    color:Theme.of(context).colorScheme ==
                                        ColorScheme.light()
                                        ? Color(0xff076579)
                                        : Color(0xffd0cfcf),
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }))
                ];
              }),
          Container(
            width: MediaQuery.of(context).size.width * .65,
            height: 40,
            child: TextField(
              controller: searchController.SearchFieldController,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 10, top: 4),
                  hintText: '${AppLocalizations.of(context)!.write_to_search}'),
            ),
          ),
          GestureDetector(
            onTap: () {
              SearchingForFacilities(context);
            },
            child: Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff076579),
              ),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget BuildTypesList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(

            itemCount: searchController.filteringTypes.length,
            // shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return BuildingTypeButton(context,index);
            }),
      ),
    );
  }
  Widget BuildingTypeButton(BuildContext context , int index){
    return Obx(() {
      return GestureDetector(
        onTap: () {
          searchController.IndexOfSelectedType(index);
          DisplayFacilityOfType();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 4, right: 4),
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color: Color(0xff076579),
                ),
                color: searchController.IndexOfSelectedType.value ==
                    index
                    ? Color(0xff076579)
                    : Theme.of(context).colorScheme ==
                    ColorScheme.light()
                    ? Color(0xffececec)
                    : Color(0xff111111)),
            child: index == 0 ? Text(
              searchController.filteringTypes[index].name,
              style: TextStyle(
                  fontSize: 15,
                  color: searchController.IndexOfSelectedType.value ==
                      index
                      ? Colors.white
                      : Theme.of(context).colorScheme ==
                      ColorScheme.dark()
                      ? Color(0xffececec)
                      : Color(0xff111111)),
            ) : Text(
              searchController.filteringTypes[index].name,
              style: TextStyle(
                  fontSize: 15,
                  color: searchController.IndexOfSelectedType.value ==
                      index
                      ? Colors.white
                      : Theme.of(context).colorScheme ==
                      ColorScheme.dark()
                      ? Color(0xffececec)
                      : Color(0xff111111)),
            ),
          ),
        ),
      );
    });
  }


  Widget BuildFacilityResultList(BuildContext context) {
    return Obx(() {
      if (searchController.IsLoading.value){
        if(searchController.TotalSearchResultsList.length == 0){
          return Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .2),
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Text('${AppLocalizations.of(context)!.no_data_to_display}'),
                ),
              )
            ],
          );
        }else{
          return Expanded(
            child: ListView.builder(
                controller: searchController.FacilitySearchScrollController,
                itemCount: searchController.NumberOfMemberInDisplayList.value+1,
                shrinkWrap: true,
                primary: false,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index < searchController.NumberOfMemberInDisplayList.value)
                    return BuildFacilityResult(context, index);
                  else {
                    if (!searchController.ArrivedToEndPage)
                      return LoadingMemberOfList(context);
                    return Container();
                  }
                }),
          );
        }

      }
      else
        return Padding(
          padding: EdgeInsets.only(left: 8,right: 8),
          child: LoadingMemberOfList(context),
        );
    });
  }

  Widget BuildFacilityResult(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Container(
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        // height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: Colors.black,
        ),
        child: ListTile(
          dense: false,
          contentPadding: EdgeInsets.all(7),
          leading: GestureDetector(
            onTap: (){
              print(searchController.DisplaySearchResultsList[index].id);
              Get.toNamed('/facility', arguments: {
                'facility_id': searchController.DisplaySearchResultsList[index].id,
                'is_user': true
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  image: DecorationImage(
                    image:GetAndCacheNetworkImageProvider(
                        searchController.DisplaySearchResultsList[index].photo),
                    onError: (err,dd){
                      print(err);
                    },
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          title: GestureDetector(
            onTap: (){
              Get.toNamed('/facility', arguments: {
                'facility_id': searchController.DisplaySearchResultsList[index].id,
                'is_user': true
              });
            },
            child: Text(
              '${searchController.DisplaySearchResultsList[index].name}',
              style: TextStyle(fontSize: 17, color: Color(0xff076579)),
            ),
          ),
          subtitle: Text(
            '${searchController.DisplaySearchResultsList[index].description}',
            style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  void SearchingForFacilities(BuildContext context) async {

    await searchController.SearchForFacilities();
  }

  void ResetLocation() {
    RefreshCountry(false);
    SelectedCountryValue = null;
    searchController.SelectedCountry('');
    SelectedCityValue = null;
    searchController.SelectedCity('');
    SelectedTownValue = null;
    searchController.SelectedTown('');
    searchController.CountryId(0);
    searchController.CityId(0);
    searchController.TownId(0);
  }

  void DisplayFacilityOfType() {
    searchController.GetTheFacilitiesResult();
  }

  void RefreshScreen (){
    searchController.Refresh();
  }
}
