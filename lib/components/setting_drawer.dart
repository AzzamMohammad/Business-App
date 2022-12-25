import 'dart:io';

import 'package:business_01/components/loading/loding_message.dart';
import 'package:business_01/l10n/l10n.dart';
import 'package:business_01/storage/shared_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../modules/complaint/complaint_server.dart';
import '../modules/logout/logout_server.dart';
import 'my_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

Widget BuildSettingDrawer(BuildContext context) {
  SharedData sharedData = SharedData();
  return ClipRRect(
    borderRadius:rtlLanguages.contains(Get.locale?.languageCode)? BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)):BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
    child: Drawer(
        child: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Setting',
            style: TextStyle(
                color: Theme.of(context).colorScheme == ColorScheme.light()
                    ? Color(0xff076579)
                    : Color(0xffefefef),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme == ColorScheme.light()
                  ? Color(0xff076579)
                  : Color(0xffefefef)),
          ListTile(
              onTap: () {
                print(Get.locale?.languageCode);
              },
              leading: Icon(Icons.language),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change language',
                    overflow: TextOverflow.ellipsis,
                  ),
                  DropdownMenuItem(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        underline: Divider(
                          thickness: 1,
                        ),
                        menuMaxHeight: 150,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        alignment: AlignmentDirectional.centerStart,
                        items: l10n.all.map((Locale lang) {
                          return DropdownMenuItem(
                            value: lang.languageCode,
                            child: Text(lang.languageCode),
                          );
                        }).toList(),
                        icon: Icon(Icons.arrow_drop_down_outlined),
                        value: Get.locale?.languageCode,
                        onChanged: (value) async {
                          Get.updateLocale(l10n.all
                              .where((lan) => lan.languageCode == value)
                              .first);
                          await sharedData.SaveAppLanguage(value!);
                        },
                      ),
                    ),
                  ),
                ],
              )),
          Divider(
            thickness: 1,
          ),
          ListTile(
              onTap: () {},
              // leading: Icon(Icons.light_mode_outlined),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text(
                  //     'Change theme',
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  Icon(Icons.light_mode_outlined),
                  BuildChangThemeButton(context),
                  Icon(Icons.dark_mode)
                ],
              )),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              BuildComplaintCard(context);
            },
            leading: Icon(Icons.contact_support_outlined),
            title: Text('Help center'),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              Logout(context);
            },
            leading: Icon(Icons.logout_outlined),
            title: Text('Logout'),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    )),
  );
}

Widget BuildChangThemeButton(BuildContext context) {
  SharedData sharedData = SharedData();
  return Switch.adaptive(
      value: Get.isDarkMode,
      onChanged: (value) {
        if (value) {
          Get.changeThemeMode(ThemeMode.dark);
          sharedData.SaveAppThemeModeIsDark(true);
        } else {
          Get.changeThemeMode(ThemeMode.light);
          sharedData.SaveAppThemeModeIsDark(false);
        }
      });
}

void BuildComplaintCard(BuildContext context) {
  Navigator.of(context).pop();
  final formKay = GlobalKey<FormState>();
  TextEditingController ComplaintTextFieldController = TextEditingController();
  TextEditingController FileTitleFieldController = TextEditingController();
  TextEditingController FileDocuFieldController = TextEditingController();
  File? ComplaintFile = null;
  PlatformFile file;
  String fileName = '';
  var IsLoaded = false.obs;
  Alert(
      context: context,
      content: Container(
        width: MediaQuery.of(context).size.width * .9,
        // height: MediaQuery.of(context).size.height * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              'Complaint',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            Padding(
                padding: EdgeInsets.only(right: 20, left: 30),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyDivider(context, 1),
                      Form(
                          key: formKay,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 10000,
                                cursorColor: Color(0xff076579),
                                controller: ComplaintTextFieldController,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  helperStyle:
                                      TextStyle(color: Color(0xff076579)),
                                  hintText: "your Complaint",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                                ),
                                onChanged: (value) {},
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      !IsLoaded.value
                          ? DialogButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );

                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  ComplaintFile = File(file.path!);
                                  fileName = file.name;
                                  IsLoaded(true);
                                }
                              },
                              width: MediaQuery.of(context).size.width * .3,
                              height: 30,
                              // padding: EdgeInsets.all(8),
                              color: Color(0xff076579),
                              child: Text(
                                'Add document',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(8),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xff076579)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${fileName}',
                                          style: TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ComplaintFile = null;
                                          fileName = '';
                                          IsLoaded(false);
                                        },
                                        child: Icon(Icons.cancel_outlined),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  autofocus: true,
                                  maxLines: 10000,
                                  cursorColor: Color(0xff076579),
                                  controller: FileTitleFieldController,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    helperStyle:
                                        TextStyle(color: Color(0xff076579)),
                                    hintText: "Document title",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                  onChanged: (value) {},
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  autofocus: true,
                                  maxLines: 2,
                                  cursorColor: Color(0xff076579),
                                  controller: FileDocuFieldController,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    helperStyle:
                                        TextStyle(color: Color(0xff076579)),
                                    hintText: "Document description",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                  onChanged: (value) {},
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            )
                    ],
                  );
                })),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          width: MediaQuery.of(context).size.width * .8,
          height: 50,
          child: Text(
            '${AppLocalizations.of(context)!.send}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            SendTheComplaint(
                ComplaintTextFieldController.value.text,
                ComplaintFile,
                FileTitleFieldController.value.text,
                FileDocuFieldController.value.text,
                context);

            print(ComplaintTextFieldController.value.text);
          },
          padding: EdgeInsets.all(8),
          color: Color(0xff076579),
        ),
      ],
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      closeIcon: Icon(
        Icons.close,
        size: 20,
      ),
      style: AlertStyle(
        backgroundColor: Theme.of(context).colorScheme == ColorScheme.light()
            ? Color(0xffececec)
            : Color(0xff181818),
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isButtonVisible: true,
        isOverlayTapDismiss: false,
        animationDuration: Duration(milliseconds: 800),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Theme.of(context).colorScheme == ColorScheme.light()
                ? Color(0xff076579)
                : Colors.white,
            // width: MediaQuery.of(context).size.width
          ),
        ),
        alertPadding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * .11),
        constraints:
            BoxConstraints.expand(width: MediaQuery.of(context).size.width),
        overlayColor: Colors.black54,
        alertElevation: 200,
        alertAlignment: Alignment.topLeft,
        buttonsDirection: ButtonsDirection.row,
      )).show();
}

void SendTheComplaint(String? Complaint, File? ComplaintFile, String? Title,
    String? description, BuildContext context) async {
  ComplaintServer complaintServer = ComplaintServer();
  LoadingMessage loadingMessage = LoadingMessage();
  bool State = false;
  SharedData sharedData = SharedData();
  String Token = await sharedData.GetToken();
  if (Complaint == '') {
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        'your Complaint is required',
        true);
    return;
  }
  loadingMessage.DisplayLoading(
    Theme.of(context).scaffoldBackgroundColor,
    Theme.of(context).primaryColor,
  );
  State = await complaintServer.SendComplaint(context, Token, Complaint!, ComplaintFile, Title, description);
  if(State){
    loadingMessage.DisplaySuccess(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        complaintServer.Message,
        true);
    Navigator.of(context).pop();
  }
  else {
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        complaintServer.Message,
        true);
  }

}

void Logout(BuildContext context) async {
  LogoutServer logoutServer = LogoutServer();
  LoadingMessage loadingMessage = LoadingMessage();
  bool SysLogoutState = false;
  SharedData sharedData = SharedData();
  String Token = await sharedData.GetToken();
  int UserId = await sharedData.GetUserID();
  loadingMessage.DisplayLoading(
    Theme.of(context).scaffoldBackgroundColor,
    Theme.of(context).primaryColor,
  );
  SysLogoutState = await logoutServer.Logout(Token, context,UserId);
  print(State);
  if (SysLogoutState) {
      loadingMessage.Dismiss();
      sharedData.DeleteEmail();
      sharedData.DeletePassword();
      sharedData.DeleteToken();
      Get.offAllNamed('/login');

  } else {
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        logoutServer.message,
        true);
  }
}
