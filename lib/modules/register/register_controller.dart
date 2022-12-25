import 'package:business_01/constants.dart';
import 'package:business_01/modules/register/register_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/user.dart';

class RegisterController extends GetxController {
  late String firstName;
  late String lastName;
  late String userGender;
  late DateTime dateOfBirth;
  late String email;
  late String password;
  late String? countryCodeNumber;
  late String? phoneNumber;
  late String? telephoneNumber;
  late String? locationDescription;
  late User user;
  late String message;
  late bool status;
  late RegisterServer registerServer;
  late SharedData sharedData;
  late TextEditingController textEditingCountryController ;
  late TextEditingController textEditingCityController ;
  late TextEditingController textEditingTownController ;
  late var CountryIndex;
  late var CityIndex;
  late var TownIndex;
  // late List<String> countryList;
  // late List<String> cityList = List.from(CityList);
  // late List<String> townList = List.from(TownList);


  @override
  void dispose() {
    textEditingCountryController.dispose();
    textEditingCityController.dispose();
    textEditingTownController.dispose();
    super.dispose();
  }

  @override
  void onInit() {

    this.firstName = "";
    this.lastName = "";
    this.userGender = "";
    this.dateOfBirth = DateTime.now();
    this.email = "";
    this.password = "";
    this.countryCodeNumber = "";
    this.phoneNumber = "";
    this.telephoneNumber = "";
    this.locationDescription = "";
    this.message = "";
    CityIndex = 0.obs;
    CountryIndex = 0.obs;
    TownIndex = 0.obs;
    // countryList = List.from(CountryList.map((country) => country.name).toList());
    // countryList = List.from(CountryList.map((country) => country.name).toList());
    // countryList = List.from(CountryList.map((country) => country.name).toList());
    sharedData = SharedData();
    registerServer = RegisterServer();
    textEditingCountryController = TextEditingController();
    textEditingCityController = TextEditingController();
    textEditingTownController = TextEditingController();

    super.onInit();
  }



  Future<void> RegisterClicked(BuildContext context) async {
    this.user = User(
      country: CountryList[CountryIndex.value].id,
      city: CountryList[CountryIndex.value].city[CityIndex.value].id,
      town: CountryList[CountryIndex.value].city[CityIndex.value].region[TownIndex.value].id,
      firstName: firstName,
      lastName: lastName,
      userGender: userGender,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      countryCodeNumber: countryCodeNumber,
      locationDescription: locationDescription,
      telephoneNumber: telephoneNumber,
    );
    status = await registerServer.SendRegister(user, context,sharedData);
    message = registerServer.message;
  }
}
