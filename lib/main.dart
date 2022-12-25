import 'package:business_01/getx_bindings/introduction_binding.dart';
import 'package:business_01/l10n/l10n.dart';
import 'package:business_01/modules/all_chats/all_chat_screen.dart';
import 'package:business_01/modules/check_PIN/check_PIN_screen.dart';
import 'package:business_01/modules/facility_images/faciity_image_screen.dart';
import 'package:business_01/modules/facility_members/facility_member_screen.dart';
import 'package:business_01/modules/home_page/home_page_screen.dart';
import 'package:business_01/modules/input_email/input_email_screen.dart';
import 'package:business_01/modules/login/login_screen.dart';
import 'package:business_01/modules/register/register_screen.dart';
import 'package:business_01/modules/splash/splash_screen.dart';
import 'package:business_01/providers/themes_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'getx_bindings/all_chat_binding.dart';
import 'getx_bindings/chat_messages_binding.dart';
import 'getx_bindings/check_PIN_binding.dart';
import 'getx_bindings/facility_binding.dart';
import 'getx_bindings/facility_image_binding.dart';
import 'getx_bindings/forget_password_binding.dart';
import 'getx_bindings/home_page_binding.dart';
import 'getx_bindings/facility_members_binding.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'getx_bindings/input_email_binding.dart';
import 'getx_bindings/login_binding.dart';
import 'getx_bindings/register_binding.dart';
import 'getx_bindings/search_binding.dart';
import 'getx_bindings/splash_bindings.dart';
import 'modules/chat_messages/chat_messages_screen.dart';
import 'modules/facility/facility_screen.dart';
import 'modules/forger_password/forget_password_screen.dart';
import 'modules/introduction/introduction_screen_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'modules/search/search_screen.dart';


void main() {

  Locale? AppLocale = null;

  runApp(
    GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      supportedLocales: l10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // localeResolutionCallback: (currentLang , supportLang){// تعطي اللديقولت للتطبيق
      //   if(currentLang != null){
      //     for(Locale locale in supportLang){
      //       if(locale.languageCode == currentLang.languageCode)
      //         AppLocale = currentLang;
      //         return currentLang;
      //     }
      //   }
      //   AppLocale = supportLang.first;
      //   return supportLang.first;
      // },
      locale: l10n.all.where((lang) => lang.languageCode == Get.deviceLocale?.languageCode).length !=0 ?l10n.all.where((lang) => lang.languageCode == Get.deviceLocale?.languageCode).first : l10n.all.first,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        // Auth routes
        GetPage(name: '/splash', page: () => SplashScreen(), binding: SplashBinding()),
        GetPage(name: '/intro', page: () => IntroductionScreenPage(), binding: IntroductionBinding()),
        GetPage(name: '/login', page: () => LoginScreen(), binding: LoginBinding()),
        GetPage(name: '/forget_password', page: () => ForgetPasswordScreen(), binding: ForgetPasswordBinding()),
        GetPage(name: '/input_email', page: () => InputEmailScreen(), binding: InputEmailBiding()),
        GetPage(name: '/register', page: () => RegisterScreen(), binding: RegisterBinding()),
        GetPage(name: '/check_pin', page: () => CheckPINScreen(), binding: CheckPINBinding()),
        //facility
        GetPage(name: '/home_page', page: () => HomePageScreen(), binding: HomePageBinding()),
        GetPage(name: '/facility', page: () => FacilityScreen(), binding: FacilityBinding()),
        GetPage(name: '/facility_image', page: () => FacilityImageScreen(), binding: FacilityImageBinding()),
        GetPage(name: '/facility_members', page: () => FacilityMembersScreen(), binding:FacilityMembersBinding()),
        //chat
        GetPage(name: '/all_chat', page: () => AllChatScreen(), binding: AllChatBinding()),
        GetPage(name: '/chat_messages', page: () => ChatMessagesScreen(), binding: ChatMessagesBinding()),
        //search
        GetPage(name: '/search', page: () => SearchScreen(), binding: SearchBinding()),


      ],
      builder: EasyLoading.init(),
    ),
  );

  ConfigEasyLoading();
}

void ConfigEasyLoading(){
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 20)
    ..indicatorType = EasyLoadingIndicatorType.foldingCube
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50
    ..radius = 10.0
    ..progressColor = Colors.green
    ..maskColor = Colors.blue
    ..userInteractions = false
    ..dismissOnTap = false;

}


//
// void main() {
//   runApp(
//     DevicePreview(builder: (context)=>GetMaterialApp(
//       builder: DevicePreview.appBuilder,
//       themeMode: ThemeMode.system,
//       theme: MyThemes.lightTheme,
//       darkTheme: MyThemes.darkTheme,
//       supportedLocales: l10n.all,
//       localizationsDelegates: [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate
//       ],
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/facility_members',
//       getPages: [
//         // Auth routes
//         GetPage(name: '/splash', page: () => SplashScreen(), binding: SplashBinding()),
//         GetPage(name: '/intro', page: () => IntroductionScreenPage(), binding: IntroductionBinding()),
//         GetPage(name: '/login', page: () => LoginScreen(), binding: LoginBinding()),
//         GetPage(name: '/forget_password', page: () => ForgetPasswordScreen(), binding: ForgetPasswordBinding()),
//         GetPage(name: '/input_email', page: () => InputEmailScreen(), binding: InputEmailBiding()),
//         GetPage(name: '/register', page: () => RegisterScreen(), binding: RegisterBinding()),
//         GetPage(name: '/check_pin', page: () => CheckPINScreen(), binding: CheckPINBinding()),
//         //
//         GetPage(name: '/home_page', page: () => HomePageScreen(), binding: HomePageBinding()),
//         GetPage(name: '/facility', page: () => FacilityScreen(), binding: FacilityBinding()),
//         GetPage(name: '/facility_image', page: () => FacilityImageScreen(), binding: FacilityImageBinding()),
//         GetPage(name: '/facility_members', page: () => FacilityMembersScreen(), binding:FacilityMembersBinding()),
//       ],
//     ),)
//   );
// }
//
// Obx((){
// return GetMaterialApp(
// themeMode: themeMode.value,
// theme: MyThemes.lightTheme,
// darkTheme: MyThemes.darkTheme,
// debugShowCheckedModeBanner: false,
// initialRoute: '/home_page',
// getPages: [
// GetPage(name: '/home_page', page: ()=>HomePageScreen(),binding: HomePageBinding()),
// ],
// );
// })
