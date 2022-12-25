import 'package:business_01/components/my_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'dart:io';

import 'image_and_video_picker.dart';


class AddAndEditMembers {

  late BuildContext context;
  String? memberName;
  String? memberDescription;
  String? memberImage;
  File? NewLoadImage;
  String? cardType;
  TextEditingController memberNameFieldController = TextEditingController();
  TextEditingController memberDescriptionFieldController = TextEditingController();

  var IsLoaded = false.obs;
  var pickingImage = false.obs;
  var Refrech = false.obs;



  AddAndEditMembers({
    required this.context,
    this.memberName,
    this.memberDescription,
    this.memberImage,
    this.cardType
  });


  String NewAddAndEditMember( void Function()? Tap) {
    final formKay = GlobalKey<FormState>();
    if(memberName != null)
      memberNameFieldController.text = '${memberName}';
    else
      memberNameFieldController.text = '';
    if(memberDescription != null)
      memberDescriptionFieldController.text = '${memberDescription}';
    else
      memberDescriptionFieldController.text = '';
    Alert(
        context: context,
        content: Container(
          width: MediaQuery.of(context).size.width * .9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 20, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          cardType != null ? '${cardType}' : '',
                          style: TextStyle(fontSize: 20 , color: Color(0xff076579)),
                        ),
                      ),
                      Form(
                          key: formKay,
                          child: Column(
                            children: [
                              MyDivider(context, 1),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 2,
                                cursorColor: Color(0xff076579),
                                controller: memberNameFieldController,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff076579)),
                                decoration: InputDecoration(
                                  helperStyle:
                                  TextStyle(color: Color(0xff076579)),
                                  hintText: memberName == null
                                      ? 'member name'
                                      : "",
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
                                onChanged: (value){
                                  this.memberName = value;
                                },

                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: 1000,
                                minLines: 1,
                                cursorColor: Theme.of(context).colorScheme ==
                                    ColorScheme.light()
                                    ? Colors.black
                                    : Colors.white,
                                controller: memberDescriptionFieldController,
                                decoration: InputDecoration(
                                  hintText: memberDescription == null
                                      ? 'member description'
                                      : "",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  // disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                                ),
                                onChanged: (value) {
                                  this.memberDescription = value;
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() {
                        if(pickingImage.value != !pickingImage.value){
                          if (memberImage != null || NewLoadImage != null)
                            return Stack(children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                    image: NewLoadImage != null
                                        ? DecorationImage(
                                      image: FileImage(NewLoadImage!),
                                      fit: BoxFit.fill,
                                    )
                                        : DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          memberImage!),
                                      fit: BoxFit.fill,
                                    )),
                                child: null,
                              ),
                              Positioned(
                                child: GestureDetector(
                                  child: Container(
                                    width: 60,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1 , color: Colors.white ),
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        color: Colors.black38
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Edit',style: TextStyle(fontSize: 14,color: Colors.white),),
                                        Icon(Icons.edit , size: 14,color: Colors.white)
                                      ],
                                    ),
                                  ),
                                  onTap: ()async{
                                    NewLoadImage = await PickImage();
                                    if (NewLoadImage != null){
                                      pickingImage(!pickingImage.value);
                                    }

                                  },
                                ),
                                right: 10,
                                top: 10,
                              ),
                            ]);
                          return GestureDetector(
                            onTap: () async {
                              NewLoadImage = await PickImage();
                              if (NewLoadImage != null)
                                pickingImage(!pickingImage.value);
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: Color(0xff076579))),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'add member image',
                                      style: TextStyle(color: Color(0xff076579)),
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: Color(0xff076579),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }else
                          return Container();
                      }),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
            ],
          ),
        ),

        buttons: [
          DialogButton(
            width: MediaQuery.of(context).size.width * .8,
            height: 50,
            child:  Text(
              '${AppLocalizations.of(context)!.send}',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: Tap,
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
    return "";
  }
}
