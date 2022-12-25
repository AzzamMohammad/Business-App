import 'package:business_01/modules/all_facility-for_owner_drawer/all_facility_for_owner_controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';

import '../modules/all_facility-for_owner_drawer/all_facility_for_owner_drawer.dart';

bool lastIndex = false;
Widget BuildBottomBar(BuildContext context,int index,GlobalKey<ScaffoldState>? _scaffoldKey) {
  return ConvexAppBar.badge(
    {1: ''},
    style: TabStyle.flip,

    items: [
      TabItem(icon: Icons.widgets_rounded, title: '${AppLocalizations.of(context)!.facility}'),
      TabItem(
          icon: Theme.of(context).colorScheme == ColorScheme.light()
              ? Image.asset('assets/icons/my_chat.png')
              : Image.asset('assets/icons/my_activ_chat.png'),
          title: '${AppLocalizations.of(context)!.chat}',
          activeIcon: Theme.of(context).colorScheme == ColorScheme.light()
              ? Image.asset('assets/icons/my_activ_chat.png')
              : Image.asset('assets/icons/my_dark_chat.png')),
      TabItem(icon: Icons.home, title: '${AppLocalizations.of(context)!.home}' ),
      TabItem(icon: Icons.search, title:'${AppLocalizations.of(context)!.search}'),
      TabItem(icon: Icons.settings, title: '${AppLocalizations.of(context)!.settings}'),
    ],
    height: 55,
    color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
    activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
    backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    badgeColor: Colors.green,
    badgeTextColor: Theme.of(context).scaffoldBackgroundColor,
    onTabNotify: (index){
      if(index == 0){
        OpenAndCloseDrawer(_scaffoldKey);
        return false;
      }
      else if (index == 1)
      {
        Get.offAllNamed('/all_chat',arguments: {'is_facility':0});
        return true;
      }
      else if (index == 2)
      {
        Get.offAllNamed('/home_page');
        return true;
      }
      else if (index == 3)
      {
        Get.offAllNamed('/search');
        return true;
      }
      else if(index == 4){
        _scaffoldKey?.currentState?.openEndDrawer();
        return false;
      }
      return true ;
    },
    initialActiveIndex:index,
  );
}

//To refresh list on close the drawer
void OpenAndCloseDrawer(GlobalKey<ScaffoldState>? _scaffoldKey){
  allFacilityForOwnerController = AllFacilityForOwnerController();
  _scaffoldKey?.currentState?.openDrawer();
}
