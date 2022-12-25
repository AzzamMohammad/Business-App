import 'dart:io';
import 'package:business_01/components/my_divider.dart';
import 'package:business_01/modules/facility_images/facility_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../components/loading/loding_message.dart';
import '../../components/post/add_and_edit_post.dart';
import '../../components/post/post_card.dart';
import '../../components/loading/loading_posts_list.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../components/sure_question_alert.dart';
import '../../constants.dart';

class FacilityImageScreen extends StatelessWidget {
  final FacilityImageController facilityImageController = Get.find();
  final LoadingMessage loadingMessage = LoadingMessage();
  final ScrollDown = true.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(facilityImageController.NumberOfListImagesItems.value == 0)
          return true;
        if(facilityImageController.scrollImageController.position.pixels == 0){
          return true;
        }else{
          facilityImageController.scrollImageController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          return false;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              facilityImageController.FacilityName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            automaticallyImplyLeading: true,
            // leadingWidth: 30,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Obx(() {
                return NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction == ScrollDirection.forward) {
                      if (ScrollDown.value != true) ScrollDown(true);
                    }
                    if (notification.direction == ScrollDirection.reverse) {
                      if (ScrollDown.value != false) ScrollDown(false);
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: RefreshImageList,
                    color: Color(0xff076579),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 5),
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount:
                      facilityImageController.NumberOfListImagesItems.value + 1,
                      primary: false,
                      controller: facilityImageController.scrollImageController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index <
                            facilityImageController.NumberOfListImagesItems.value) {
                          return PostListTile(
                            context,
                            facilityImageController.IsUser,
                            facilityImageController.FacilityImage,
                            facilityImageController.FacilityName,
                            facilityImageController
                                .FacilityImagesList[index].createdAt,
                            facilityImageController.FacilityImagesList[index].title,
                            facilityImageController
                                .FacilityImagesList[index].description,
                            facilityImageController
                                .FacilityImagesList[index].photo ==
                                null
                                ? ""
                                : facilityImageController
                                .FacilityImagesList[index].photo!,
                                (context) =>
                            [
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${AppLocalizations.of(context)!.update}'),
                                    Icon(Icons.update),
                                  ],
                                ),
                                onTap: () {
                                  AddAndEditPost EditImagePost = AddAndEditPost(
                                      context: context,
                                      facilityName:
                                      facilityImageController.FacilityName,
                                      facilityImage:
                                      facilityImageController.FacilityImage,
                                      postImage: facilityImageController
                                          .FacilityImagesList[index].photo,
                                      postType: PostType[0],
                                      PostVideo: facilityImageController
                                          .FacilityImagesList[index].video,
                                      postTitle: facilityImageController
                                          .FacilityImagesList[index].title,
                                      postDescription: facilityImageController
                                          .FacilityImagesList[index].description);

                                  Future.delayed(
                                      Duration(seconds: 0),
                                          () async =>
                                          EditImagePost.NewAddAndEditPost(() {
                                            SendEditingImagePost(
                                                context, EditImagePost,
                                                facilityImageController
                                                    .FacilityImagesList[index].id);
                                          })
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: MyDivider(context, .3),
                                // padding: EdgeInsets.only(top: 0,bottom: 0),
                                height: 20,
                              ),
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.delete}',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Future.delayed(
                                      Duration(seconds: 0),
                                          () async =>
                                          DeleteImagePost(
                                              context, facilityImageController
                                              .FacilityImagesList[index].id,index)
                                  );
                                },
                              ),
                            ],
                            0
                          );
                        } else {
                          if (!facilityImageController
                              .ArrivedToLastFacilityImagesPage)
                            return LoadingPostList(context);
                          return Container();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
          floatingActionButton: facilityImageController.IsUser ? Container() : Obx(() {
            if (ScrollDown.value)
              return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  width: 150,
                  height: 50,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      AddNewImagePost(context);
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      '${AppLocalizations.of(context)!.new_image}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Color(0xff076579),
                  ));
            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              width: 50,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  AddNewImagePost(context);
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),

                backgroundColor: Color(0xff076579),
              ),
            );
          })),
    );
  }

  void AddNewImagePost(BuildContext context) {
    AddAndEditPost AddNewImage = AddAndEditPost(
        context: context,
        facilityName: facilityImageController.FacilityName,
        facilityImage: facilityImageController.FacilityImage,
        postType: PostType[0]);
    AddNewImage.NewAddAndEditPost(() {
      SendNewImagePost(context, AddNewImage);
    });
  }

  void SendNewImagePost(BuildContext context, AddAndEditPost NewPost) async {
    loadingMessage.DisplayLoading(
      Theme
          .of(context)
          .scaffoldBackgroundColor,
      Theme
          .of(context)
          .primaryColor,
    );
    if (NewPost.postTitle == null) {
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          '${AppLocalizations.of(context)!.post_title_is_required}',
          true);
    }
    if (NewPost.postDescription == null) {
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          '${AppLocalizations.of(context)!.post_description_is_required}',
          true);
    }
    if (NewPost.NewLoadImage == null){
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          '${AppLocalizations.of(context)!.post_image_is_required}',
          true);
    }
     facilityImageController.PostTitle = NewPost.postTitle!;
      facilityImageController.PostDescription = NewPost.postDescription!;
      facilityImageController.PostImageFile = File(NewPost.NewLoadImage!.path);
    if (NewPost.NewLoadVideo != null)
      facilityImageController.PostVideoFile = File(NewPost.NewLoadVideo!.path);
    await facilityImageController.SendNewImagePost(context);
    if (facilityImageController.State) {
      loadingMessage.DisplaySuccess(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          facilityImageController.Message,
          false);
      await RefreshImageList();
      Navigator.of(context).pop();
    } else {
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          facilityImageController.Message,
          true);
    }
    facilityImageController.PostImageFile = null;
    facilityImageController.PostVideoFile = null;
  }

  void SendEditingImagePost(BuildContext context, AddAndEditPost EditPost,
      int PostId) async {
    loadingMessage.DisplayLoading(
      Theme
          .of(context)
          .scaffoldBackgroundColor,
      Theme
          .of(context)
          .primaryColor,
    );
    if (EditPost.postTitle == '') {
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          '${AppLocalizations.of(context)!.post_title_is_required}',
          true);
    }
    if (EditPost.postDescription == '') {
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          '${AppLocalizations.of(context)!.post_description_is_required}',
          true);
    }


    if (EditPost.NewLoadImage != null){

      facilityImageController.PostImageFile = File(EditPost.NewLoadImage!.path);
    }

    if (EditPost.NewLoadVideo != null)
      facilityImageController.PostVideoFile = File(EditPost.NewLoadVideo!.path);
    facilityImageController.PostTitle = EditPost.postTitle!;
    facilityImageController.PostDescription = EditPost.postDescription!;
    facilityImageController.PostId = PostId;
    await facilityImageController.SendEditImagePost(context);
    if (facilityImageController.State) {
      loadingMessage.DisplaySuccess(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          facilityImageController.Message,
          true);
      await RefreshImageList();
      Navigator.of(context).pop();
    } else {
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          facilityImageController.Message,
          true);
    }
    facilityImageController.PostImageFile = null;
    facilityImageController.PostVideoFile = null;

  }

  void DeleteImagePost(BuildContext context, int PostId , int index) {
    SureQuestionAlert(() {
      SendDeletedPost(context, PostId , index);
    }, context);
  }

  void SendDeletedPost(BuildContext context, int PostId , int index) async {
    loadingMessage.DisplayLoading(
      Theme
          .of(context)
          .scaffoldBackgroundColor,
      Theme
          .of(context)
          .primaryColor,
    );
    facilityImageController.PostId = PostId;
    await facilityImageController.SendDeletePost(context);
    if (facilityImageController.State) {
      loadingMessage.DisplaySuccess(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          facilityImageController.Message,
          true);
      await RefreshImageList();
      Navigator.of(context).pop();
    } else {
      loadingMessage.DisplayError(
          Theme
              .of(context)
              .scaffoldBackgroundColor,
          Theme
              .of(context)
              .primaryColor,
          Theme
              .of(context)
              .primaryColor,
          facilityImageController.Message,
          true);
    }
  }

  Future<void> RefreshImageList()async{
    facilityImageController.RefreshImageScreen();

  }
}
