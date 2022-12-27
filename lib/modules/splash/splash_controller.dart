import 'package:business_01/components/loading/loding_message.dart';
import 'package:business_01/modules/splash/splash_server.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';
import 'package:business_01/l10n/l10n.dart';
import 'package:business_01/models/location.dart';

import '../../components/handling_chat.dart';
import '../../config/pusher_config.dart';
import '../../constants.dart';


class SplashController extends GetxController {
  late SharedData sharedData;
  late bool state;
  late LoadingMessage loadingMessage;

  late SplashServer splashServer;
  late BuildContext? buildContext;
  String? UserLanguageApp;
  bool? UserThemeMode;

  @override
  void onInit() async{
    sharedData = SharedData();
    state = false;
    splashServer = SplashServer();
    loadingMessage = LoadingMessage();
    UserLanguageApp = await sharedData.GetAppLanguage();
    UserThemeMode = await sharedData.GetAppThemeModeIsDark();
    GetUserThemeMode();

    super.onInit();
  }

  @override
  void onReady()async {
    GetUserLang();
   await GetCountryAndCityList();

    GoTo();

    super.onReady();
  }

  void GetUserThemeMode(){
    if(UserThemeMode!=null){
      if(UserThemeMode!)
        Get.changeThemeMode(ThemeMode.dark);
      else
        Get.changeThemeMode(ThemeMode.light);
    }

  }

  void GetUserLang(){
    if(UserLanguageApp != null)
      Get.updateLocale(l10n.all.where((lan) => lan.languageCode == UserLanguageApp).first);
  }

  Future<void> GetCountryAndCityList()async{
    while(CountryList.isEmpty){
      CountryList=await splashServer.GetAllCountriesAndCitiesAndTowns();
    }

    print(CountryList.toList());
  }
  void GoTo() async {
    String Email = await sharedData.GetEmail();
    String Password = await sharedData.GetPassword();
    if (Email == '' || Password == '') {
      GoToInitScreen();
    } else {
      AbelToLogin(Email, Password);
    }
  }

  void GoToInitScreen() {
    Get.offAllNamed('/intro');
  }

  void AbelToLogin(String Email, String Password) async {
    int temp = 0;
    while (!splashServer.GetResponse) {
      state = await splashServer.CheckLoginInfo(Email, Password, sharedData);
      if (temp != 0 && state == false) {
        loadingMessage.DisplayToast(
          Theme.of(buildContext!).primaryColor,
          Theme.of(buildContext!).primaryColor,
          Colors.white,
          AppLocalizations.of(buildContext!)!.check_your_connection,
          false,
        );
      }
      temp++;
    }
    if (state) {
      Get.offAllNamed('/home_page');
      LaravelEcho.init(Token: await sharedData.GetToken());
      ListenToThePusherUserChatChannel(await sharedData.GetUserID() ,await sharedData.GetToken());
    } else {
      if (splashServer.isConfirm) {
        Get.offAllNamed('/login');
      } else {
        loadingMessage.DisplayToast(
          Theme.of(buildContext!).primaryColor,
          Theme.of(buildContext!).primaryColor,
          Colors.white,
          AppLocalizations.of(buildContext!)!
              .you_must_confirm_your_account_the_code_has_been_sent_to_your_email,
          false,);
        Get.offAllNamed('/check_pin');
      }
    }
  }


}
