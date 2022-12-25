import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:video_player/video_player.dart';

import '../cach_image_from_network.dart';
import '../image_and_video_picker.dart';
import '../my_divider.dart';
import 'dart:io';

import 'display_video.dart';

class AddAndEditPost {

  late BuildContext context;
  late String facilityName;
  late String facilityImage;

  String? postType;
  String? postTitle;
  String? postDescription;
  String? postImage;
  String? PostVideo;
  File? NewLoadImage;
  File? NewLoadVideo;
  TextEditingController titleFieldController = TextEditingController();
  TextEditingController descriptionFieldController = TextEditingController();
  int IndexOfTypeAddPostJopOrOffer = 0;

  var IsLoaded = false.obs;
  var pickingImage = false.obs;
  var pickingVideo = false.obs;
  var Refrech = false.obs;



  AddAndEditPost({
    required this.context,
    required this.facilityName,
    required this.facilityImage,
    this.postType,
    this.postTitle,
    this.postDescription,
    this.postImage,
    this.PostVideo,
  });


  String NewAddAndEditPost( void Function()? Tap) {
    final formKay = GlobalKey<FormState>();
    List<String> postTypeList = [
      '${AppLocalizations.of(context)!.job}',
      '${AppLocalizations.of(context)!.offer}'
    ];
    var SelectedValue = '${postTypeList[0]}'.obs;
    if(postTitle != null)
      titleFieldController.text = '${postTitle}';
    else
      titleFieldController.text = '';
    if(postDescription != null)
      descriptionFieldController.text = '${postDescription}';
    else
      descriptionFieldController.text = '';

    VideoPlayerController videoNetworkController  = VideoPlayerController.network('');
    VideoPlayerController videoFileController = VideoPlayerController.file(File(''));

    if(PostVideo != null){
      videoNetworkController = VideoPlayerController.network(PostVideo!);
    }


    Alert(
        context: context,
        content: Container(
          width: MediaQuery.of(context).size.width * .9,
          // height: MediaQuery.of(context).size.height * .8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image:GetAndCacheNetworkImageProvider(
                                facilityImage),
                            onError: (err,dd){
                              print(err);
                            },
                            fit: BoxFit.cover,
                          )),
                      child: null),
                  title: Text(
                    "${facilityName}",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: postType == null
                      ? Container(
                          width: 150,
                          height: 30,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          // margin: EdgeInsets.only(left: 20 ,right: 20),
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.only( Radius.circular(8)),
                              border: BorderDirectional(
                            bottom:
                                BorderSide(width: 1, color: Color(0xff076579)),
                          )),
                          child: Obx(() {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                alignment: AlignmentDirectional.centerStart,
                                dropdownColor: Theme.of(context).colorScheme ==
                                        ColorScheme.light()
                                    ? Color(0xfff1f1f1)
                                    : Color(0xff252525),

                                items: postTypeList.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),

                                isExpanded: true,
                                // underline: Divider(thickness: 2,color: Color(0xff076579),height: 20,),
                                icon: Icon(Icons.arrow_drop_down_outlined),
                                value: SelectedValue.value,
                                onChanged: (value) {
                                  IndexOfTypeAddPostJopOrOffer = postTypeList.indexOf(value!);
                                  print(IndexOfTypeAddPostJopOrOffer);
                                  SelectedValue(value);
                                },
                              ),
                            );
                          }),
                        )
                      : Container(
                          height: 1,
                          child: SizedBox(),
                        )),
              Padding(
                  padding: EdgeInsets.only(right: 20, left: 30),
                  child: Column(
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
                                maxLines: 2,
                                cursorColor: Color(0xff076579),
                                controller: titleFieldController,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xff076579)),
                                decoration: InputDecoration(
                                  helperStyle:
                                      TextStyle(color: Color(0xff076579)),
                                  hintText: postTitle == null
                                      ? '${AppLocalizations.of(context)!.post_title}'
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
                                  this.postTitle = value;
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
                                controller: descriptionFieldController,
                                decoration: InputDecoration(
                                  hintText: postDescription == null
                                      ? '${AppLocalizations.of(context)!.post_description}'
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
                                  this.postDescription = value;
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() {
                       if(pickingImage.value != !pickingImage.value){
                         if (postImage != null || NewLoadImage != null)
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
                                         postImage!),
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
                                     '${AppLocalizations.of(context)!.add_image}',
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
                        height: 10,
                      ),
                      // Obx(() {
                      //   if(pickingVideo.value != !pickingVideo.value){
                      //     if (PostVideo != null || NewLoadVideo != null)
                      //       return Stack(children: [
                      //         Container(
                      //           height: 150,
                      //           decoration: BoxDecoration(
                      //               borderRadius:
                      //               BorderRadius.all(Radius.circular(8))),
                      //           child: NewLoadVideo != null ? Text("data"):DisplayVideo(videoNetworkController , context),
                      //         ),
                      //         Positioned(
                      //           child: GestureDetector(
                      //             child: Container(
                      //               width: 60,
                      //               height: 30,
                      //               decoration: BoxDecoration(
                      //                   border: Border.all(width: 1 , color: Colors.white ),
                      //                   borderRadius: BorderRadius.all(Radius.circular(8)),
                      //                   color: Colors.black38
                      //               ),
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //                 children: [
                      //                   Text('Edit',style: TextStyle(fontSize: 14,color: Colors.white),),
                      //                   Icon(Icons.edit , size: 14,color: Colors.white)
                      //                 ],
                      //               ),
                      //             ),
                      //             onTap: ()async{
                      //               NewLoadVideo = await PickImage();
                      //               if (NewLoadVideo != null){
                      //                 pickingVideo(!pickingVideo.value);
                      //                 videoFileController = VideoPlayerController.file(NewLoadVideo!);
                      //               print(NewLoadVideo);
                      //               }
                      //
                      //             },
                      //           ),
                      //           right: 10,
                      //           top: 10,
                      //         ),
                      //       ]);
                      //     return GestureDetector(
                      //       onTap: () async {
                      //         NewLoadVideo = await PickVideo();
                      //         if (NewLoadVideo != null){
                      //           pickingVideo(!pickingVideo.value);
                      //           videoFileController = VideoPlayerController.file(NewLoadVideo!);
                      //         }
                      //       },
                      //       child: Container(
                      //         height: 150,
                      //         decoration: BoxDecoration(
                      //             borderRadius:
                      //             BorderRadius.all(Radius.circular(8)),
                      //             border: Border.all(color: Color(0xff076579))),
                      //         child: Center(
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 '${AppLocalizations.of(context)!.add_video}',
                      //                 style: TextStyle(color: Color(0xff076579)),
                      //               ),
                      //               Icon(
                      //                 Icons.add,
                      //                 color: Color(0xff076579),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   }else
                      //     return Container();
                      // }),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
            ],
          ),
        ),
        // closeFunction: (){
        //   print('mjjjj');
        //   videoNetworkController.dispose();
        //   videoFileController.dispose();
        //   Navigator.of(context).pop();
        // },
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
