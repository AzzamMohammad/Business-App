import 'dart:io';
import 'package:business_01/components/get_path_to_facility.dart';
import 'package:business_01/modules/facility/facility_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import '../../components/cach_image_from_network.dart';
import '../../components/loading/loding_message.dart';
import '../../components/post/add_and_edit_post.dart';
import '../../components/post/post_card.dart';
import '../../components/loading/loading_facility_home.dart';
import '../../components/loading/loading_facility_image.dart';
import '../../components/loading/loading_image_from_nwtwork.dart';
import '../../components/loading/loading_posts_list.dart';
import '../../components/my_divider.dart';
import '../../components/sure_question_alert.dart';
import '../../constants.dart';
import '../../models/facility_images_pagination.dart';

class FacilityScreen extends StatelessWidget {
  final ListOfPosts = [];
  final ReturnResultOfFollowRequest = true.obs;
  final LoadingMessage loadingMessage = LoadingMessage();
  final GlobalKey AppBarKay = GlobalKey();

  FacilityController facilityController = Get.find();

  List<String> facilityImages = [];

  Widget LineaDescription(String Type, String Value, BuildContext context) {
    return RichText(
      text: TextSpan(
          style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme == ColorScheme.light()
                  ? Colors.black
                  : Colors.white),
          children: [
            // TextSpan(
            //   text: Type,
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // TextSpan(
            //   text: ' : ',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            TextSpan(
              text: Value,
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(facilityController.FacilityScrollController.position.pixels != 0){
          facilityController.FacilityScrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          return false;
        }
        return true;

      },
      child: Scaffold(
        body: Obx(() {
          if (!facilityController.IsLoadedInfo.value) {
            return LoadingFacilityHome(context);
          } else {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: RefreshFacilityName,
                color: Color(0xff076579),
                child: CustomScrollView(
                  controller: facilityController.FacilityScrollController,
                  slivers: [
                    SliverAppBar(
                      key: AppBarKay,
                      expandedHeight: MediaQuery.of(context).size.height * .35,
                      automaticallyImplyLeading: true,
                      actions: [
                        !facilityController.IsUser
                            ? GestureDetector(
                                onTap: () {
                                  Get.toNamed('/all_chat',
                                      arguments: {'is_facility': 1,'facility_id':facilityController.facilityInformation.id});
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset('assets/icons/facility_chat.png'),
                                ),
                              )
                            : Container(),
                        facilityController.IsUser
                            ? Container()
                            : PopupMenuButton<Widget>(
                                icon: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Icon(
                                    Icons.more_vert,
                                  ),
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * .4,
                                  minWidth: MediaQuery.of(context).size.width * .4,
                                ),
                                color: Theme.of(context).colorScheme ==
                                        ColorScheme.light()
                                    ? Color(0xffefefef)
                                    : Color(0xff1a1a1a),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.members}',
                                              style: TextStyle(),
                                            ),
                                            Icon(
                                              Icons.people,
                                              color: null,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Future.delayed(
                                              Duration(seconds: 0),
                                              () => Get.toNamed('/facility_members',
                                                      arguments: {
                                                        'facility_id':
                                                            facilityController
                                                                .facilityInformation
                                                                .id,
                                                        'is_user':facilityController.IsUser
                                                      }));
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: MyDivider(context, .3),
                                        // padding: EdgeInsets.only(top: 0,bottom: 0),
                                        height: 20,
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.update}',
                                            ),
                                            Icon(
                                              Icons.update,
                                            ),
                                          ],
                                        ),
                                        onTap: () {},
                                      )
                                    ]),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: GetAndCacheNetworkImage(
                            '${facilityController.facilityInformation.photo}',
                            (context, url) => Center(
                                child: DisplayLoading(
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height * .415)),
                            BoxFit.cover),
                      ),
                      title: Text(
                        '${facilityController.facilityInformation.name}',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        // maxFontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(left: 8, top: 10, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // AutoSizeText(
                          //   textAlign: TextAlign.center,
                          //   'We have all products at competitive prices that are the same for everyone ',
                          //   style: TextStyle(fontSize: 15),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            facilityController.facilityInformation.description,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/icons/world.png',
                                // color: Theme.of(context).colorScheme ==
                                //         ColorScheme.light()
                                //     ? Colors.black
                                //     : Colors.white,
                                width: 20,
                                height: 20,
                              ),

                              SizedBox(
                                width: 10,
                              ),
                                LineaDescription(
                                    '${AppLocalizations.of(context)!.country}',
                                    '${facilityController.facilityInformation.country.name}',
                                    context),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/icons/home_icon.png',
                                // color: Theme.of(context).colorScheme ==
                                //         ColorScheme.light()
                                //     ? Colors.black
                                //     : Colors.white,
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                                LineaDescription(
                                    '${AppLocalizations.of(context)!.city}',
                                    '${facilityController.facilityInformation.city.name}',
                                    context),
                            ],
                          ),

                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/icons/location_town_icon.png',
                                // color: Theme.of(context).colorScheme ==
                                //         ColorScheme.light()
                                //     ? Colors.black
                                //     : Colors.white,
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              LineaDescription(
                                  '${AppLocalizations.of(context)!.town}',
                                  '${facilityController.facilityInformation.region.name}',
                                  context),
                            ],
                          ),

                          SizedBox(
                            height: 14,
                          ),
                          facilityController.IsUser
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() {
                                      return ElevatedButton(
                                          onPressed: () async {
                                            ReturnResultOfFollowRequest(false);
                                            ReturnResultOfFollowRequest(await FollowAndUnfollowTheFoundation(context));
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: facilityController
                                                    .UserFollowTheFoundation
                                                ? MaterialStateProperty.all<
                                                    Color>(Color(0xff076579))
                                                : (Theme.of(context)
                                                            .colorScheme ==
                                                        ColorScheme.light()
                                                    ? MaterialStateProperty.all<
                                                        Color>(Color(0xfff5f6f6))
                                                    : MaterialStateProperty.all<
                                                            Color>(
                                                        Color(0xff090909))),
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .6,
                                                        40)),
                                            maximumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .6,
                                                        40)),
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color(0xff076579),
                                                    width: 2),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: ReturnResultOfFollowRequest.value
                                              ? (facilityController
                                                      .UserFollowTheFoundation
                                                  ? Container(
                                                      width: 20,
                                                      height: 20,
                                                      child: Image.asset(
                                                          'assets/icons/unFollow.png'))
                                                  : Image.asset(
                                                      width: 20,
                                                      height: 20,
                                                      'assets/icons/Follow.png'))
                                              : Container(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:facilityController.UserFollowTheFoundation? Color(0xfff5f6f6):Color(0xff076579),
                                                    strokeWidth: 3,
                                                  )));
                                    }),
                                    ElevatedButton(
                                      onPressed: () {
                                        GoToFacilityUserChat(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: (Theme.of(context)
                                                    .colorScheme ==
                                                ColorScheme.light()
                                            ? MaterialStateProperty.all<Color>(
                                                Color(0xfff5f6f6))
                                            : MaterialStateProperty.all<Color>(
                                                Color(0xff090909))),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15,
                                                40)),
                                        maximumSize:
                                            MaterialStateProperty.all<Size>(Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15,
                                                40)),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xff076579),
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Image.asset(
                                          width: 20,
                                          height: 20,
                                          'assets/icons/user_facility_chat.png'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed('/facility_members',
                                            arguments: {
                                              'facility_id':
                                              facilityController
                                                  .facilityInformation
                                                  .id,
                                              'is_user':facilityController.IsUser
                                            });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: (Theme.of(context)
                                                    .colorScheme ==
                                                ColorScheme.light()
                                            ? MaterialStateProperty.all<Color>(
                                                Color(0xfff5f6f6))
                                            : MaterialStateProperty.all<Color>(
                                                Color(0xff090909))),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15,
                                                40)),
                                        maximumSize:
                                            MaterialStateProperty.all<Size>(Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15,
                                                40)),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xff076579),
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Image.asset(
                                          width: 25,
                                          height: 25,
                                          'assets/icons/member_icon_button.png'),
                                    ),
                                  ],
                                )
                              : Container(),
                          // MyDivider(context, 1),
                          // SizedBox(
                          //   height: 14,
                          // ),
                          // Center(
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       final GetPathToFacility getPathToFacility =
                          //           GetPathToFacility(
                          //               facilityX: 33.4979003,
                          //               facilityY: 36.3164717);
                          //       getPathToFacility.GetPath();
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         Icon(Icons.location_on_outlined,
                          //             size: 25,
                          //             color: Theme.of(context).primaryColor),
                          //         AutoSizeText(
                          //           '${AppLocalizations.of(context)!.go_to_location}',
                          //           maxFontSize: 16,
                          //           minFontSize: 14,
                          //           style: TextStyle(
                          //               color: Theme.of(context).primaryColor,
                          //               fontWeight: FontWeight.normal),
                          //         )
                          //       ],
                          //     ),
                          //     style: ButtonStyle(
                          //       backgroundColor: MaterialStateProperty.all<Color>(
                          //           Theme.of(context).scaffoldBackgroundColor),
                          //       minimumSize:
                          //           MaterialStateProperty.all<Size>(Size(10, 35)),
                          //       maximumSize: MaterialStateProperty.all<Size>(Size(
                          //           MediaQuery.of(context).size.width * .5, 35)),
                          //       // textStyle: MaterialStateProperty.all<TextStyle>(
                          //       //   TextStyle( fontWeight: FontWeight.bold),
                          //       // ),
                          //       shape: MaterialStateProperty.all<OutlinedBorder>(
                          //         RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.all(
                          //             Radius.circular(12),
                          //           ),
                          //           side: BorderSide(
                          //             color: Theme.of(context).primaryColor,
                          //             width: 3,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 7,
                          // ),
                          // Text(
                          //   facilityController.facilityInformation.description,
                          //   style: TextStyle(fontSize: 18),
                          // ),
                          // SizedBox(
                          //   height: 14,
                          // ),
                          // MyDivider(context, 1),
                          SizedBox(
                            height: 7,
                          ),
                          !facilityController.IsUser
                              ? Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      AddNewJopOfferPost(context);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).colorScheme ==
                                                        ColorScheme.light()
                                                    ? Color(0xffececec)
                                                    : Color(0xff111111),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              ListTile(
                                                leading: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100)),
                                                        image: DecorationImage(
                                                          image: GetAndCacheNetworkImageProvider(
                                                              facilityController
                                                                  .facilityInformation
                                                                  .photo),
                                                          onError: (err, ss) {
                                                            print(err);
                                                          },
                                                          fit: BoxFit.cover,
                                                        )),
                                                    child: null),
                                                title: Text(
                                                  "${facilityController.facilityInformation.name}",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20, left: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    MyDivider(context, 1),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          right: 20,
                                                          left: 30),
                                                      child: Text(
                                                        "what are you thinking about ? ....",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xffa19e9e)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),

                          MyDivider(context, 1),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.facility_images}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // FacilityNameInImageScreen = facilityController
                                  //     .facilityInformation.name;
                                  // FacilityImageInImageScreen =
                                  //     facilityController
                                  //         .facilityInformation.photo;
                                  Get.toNamed('/facility_image', arguments: {
                                    'facility_id':
                                        facilityController.facilityInformation.id,
                                    'IsUser': facilityController.IsUser,
                                    'facility_image': facilityController
                                        .facilityInformation.photo,
                                    'facility_name': facilityController
                                        .facilityInformation.name
                                  });
                                },
                                child: Text(
                                  '${AppLocalizations.of(context)!.show_all_images}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          facilityController.IsLoadedImage.value == false
                              ? LoadingFacilityImage(context)
                              : PhotoFacility(
                                  context, facilityController.FacilityImagesList),
                          SizedBox(
                            height: 14,
                          ),
                          MyDivider(context, 1),
                          Obx(() {
                            if (facilityController.selectJobs.value) {
                              return Column(
                                children: [
                                  SelectedTypeDisplay(context),
                                  ListView.builder(
                                    padding: EdgeInsets.only(top: 20),
                                    itemCount: facilityController
                                            .NumberOfListJobsItems.value +
                                        1,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      if (index <
                                          facilityController
                                              .FacilityJobsList.length) {
                                        return PostListTile(
                                            context,
                                            facilityController.IsUser,
                                            facilityController
                                                .facilityInformation.photo,
                                            facilityController
                                                .facilityInformation.name,
                                            facilityController
                                                .FacilityJobsList[index]
                                                .createdAt,
                                            facilityController
                                                .FacilityJobsList[index].title,
                                            facilityController
                                                .FacilityJobsList[index]
                                                .description,
                                            facilityController
                                                        .FacilityJobsList[index]
                                                        .photo ==
                                                    null
                                                ? ""
                                                : facilityController
                                                    .FacilityJobsList[index]
                                                    .photo!,
                                            (context) => [
                                                  PopupMenuItem(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            '${AppLocalizations.of(context)!.update}'),
                                                        Icon(Icons.update),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      AddAndEditPost EditJopPost = AddAndEditPost(
                                                          context: context,
                                                          facilityName: facilityController
                                                              .facilityInformation
                                                              .name,
                                                          facilityImage:
                                                              facilityController
                                                                  .facilityInformation
                                                                  .photo,
                                                          postImage: facilityController
                                                              .FacilityJobsList[
                                                                  index]
                                                              .photo,
                                                          postType: PostType[1],
                                                          PostVideo: facilityController
                                                              .FacilityJobsList[
                                                                  index]
                                                              .video,
                                                          postTitle: facilityController
                                                              .FacilityJobsList[
                                                                  index]
                                                              .title,
                                                          postDescription:
                                                              facilityController
                                                                  .FacilityJobsList[index]
                                                                  .description);
                                                      Future.delayed(
                                                          Duration(seconds: 0),
                                                          () async => EditJopPost
                                                                  .NewAddAndEditPost(
                                                                      () {
                                                                SendEditingJopPost(
                                                                    context,
                                                                    EditJopPost,
                                                                    facilityController
                                                                        .FacilityJobsList[
                                                                            index]
                                                                        .id);
                                                              }));
                                                    },
                                                  ),
                                                  PopupMenuItem(
                                                    child: MyDivider(context, .3),
                                                    // padding: EdgeInsets.only(top: 0,bottom: 0),
                                                    height: 20,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${AppLocalizations.of(context)!.delete}',
                                                          style: TextStyle(
                                                              color: Colors.red),
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
                                                          () async => DeleteJopPost(
                                                              context,
                                                              facilityController
                                                                  .FacilityJobsList[
                                                                      index]
                                                                  .id,
                                                              index));
                                                    },
                                                  )
                                                ],
                                            0);
                                      } else {
                                        if (!facilityController
                                            .ArrivedToLastFacilityJobsPage)
                                          return LoadingPostList(context);
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  SelectedTypeDisplay(context),
                                  ListView.builder(
                                    padding: EdgeInsets.only(top: 20),
                                    itemCount: facilityController
                                            .NumberOfListOffersItem.value +
                                        1,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      if (index <
                                          facilityController
                                              .FacilityOffersList.length) {
                                        return PostListTile(
                                            context,
                                            facilityController.IsUser,
                                            facilityController
                                                .facilityInformation.photo,
                                            facilityController
                                                .facilityInformation.name,
                                            facilityController
                                                .FacilityOffersList[index]
                                                .createdAt,
                                            facilityController
                                                .FacilityOffersList[index].title,
                                            facilityController
                                                .FacilityOffersList[index]
                                                .description,
                                            facilityController
                                                        .FacilityOffersList[index]
                                                        .photo ==
                                                    null
                                                ? ""
                                                : facilityController
                                                    .FacilityOffersList[index]
                                                    .photo!,
                                            (context) => [
                                                  PopupMenuItem(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            '${AppLocalizations.of(context)!.update}'),
                                                        Icon(Icons.update),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      AddAndEditPost EditOfferPost = AddAndEditPost(
                                                          context: context,
                                                          facilityName: facilityController
                                                              .facilityInformation
                                                              .name,
                                                          facilityImage: facilityController
                                                              .facilityInformation
                                                              .photo,
                                                          postImage: facilityController
                                                              .FacilityOffersList[
                                                                  index]
                                                              .photo,
                                                          postType: PostType[2],
                                                          PostVideo: facilityController
                                                              .FacilityOffersList[
                                                                  index]
                                                              .video,
                                                          postTitle: facilityController
                                                              .FacilityOffersList[
                                                                  index]
                                                              .title,
                                                          postDescription:
                                                              facilityController
                                                                  .FacilityOffersList[index]
                                                                  .description);
                                                      Future.delayed(
                                                          Duration(seconds: 0),
                                                          () async =>
                                                              EditOfferPost
                                                                  .NewAddAndEditPost(
                                                                      () {
                                                                SendEditingOfferPost(
                                                                    context,
                                                                    EditOfferPost,
                                                                    facilityController
                                                                        .FacilityOffersList[
                                                                            index]
                                                                        .id);
                                                              }));
                                                    },
                                                  ),
                                                  PopupMenuItem(
                                                    child: MyDivider(context, .3),
                                                    // padding: EdgeInsets.only(top: 0,bottom: 0),
                                                    height: 20,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${AppLocalizations.of(context)!.delete}',
                                                          style: TextStyle(
                                                              color: Colors.red),
                                                        ),
                                                        Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Future.delayed(
                                                          Duration(seconds: 0),
                                                          () async => DeleteOfferPost(
                                                              context,
                                                              facilityController
                                                                  .FacilityOffersList[
                                                                      index]
                                                                  .id,
                                                              index));
                                                    },
                                                  )
                                                ],
                                            0);
                                      } else {
                                        if (!facilityController
                                            .ArrivedToLastFacilityOfferPage)
                                          return LoadingPostList(context);
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              );
                            }
                          }),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          }
        }),
        // bottomNavigationBar:facilityController.IsUser == true ? Container(width: 0,height: 0,): BuildBottomBar(context, 0,null),
      ),
    );
  }

  Widget PhotoFacility(BuildContext context, List<FacilityImage> ImagesList) {
    return GridView.builder(
        controller: facilityController.scrollImageController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width ~/ 100,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
        padding: EdgeInsets.only(top: 0),
        primary: false,
        shrinkWrap: true,
        itemCount:
            ImagesList.length < ((MediaQuery.of(context).size.width ~/ 100) * 2)
                ? ImagesList.length
                : ((MediaQuery.of(context).size.width ~/ 100) * 2),
        itemBuilder: (context, index) {
          print(MediaQuery.of(context).size.width ~/ 3);
          return GridTile(
              child: GetAndCacheNetworkImageWithoutLoading(
                  '${ImagesList[index].photo}', BoxFit.fill)

              // GetAndCacheNetworkImage(
              //     '${ImagesList[index].photo}',
              //     (context, url) => Center(
              //           child: DisplayLoading(
              //               MediaQuery.of(context).size.width * .3,
              //               MediaQuery.of(context).size.width * .3),
              //         ),
              //     BoxFit.fill),
              );
        });
  }

  Widget SelectedTypeDisplay(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              facilityController.selectJobs(true);
              ListOfPosts.add([3, 4]);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              height: 40,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: facilityController.selectJobs == true ? Colors.black54 : Colors.black12,
              ),
              child: Center(
                  child: Text(
                '${AppLocalizations.of(context)!.jobs}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme == ColorScheme.light()
                        ? Colors.black
                        : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              facilityController.selectJobs(false);
              GetNewOfferClicked(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              height: 40,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: facilityController.selectJobs == false ? Colors.black54 : Colors.black12,
              ),
              child: Center(
                  child: Text(
                '${AppLocalizations.of(context)!.offers}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme == ColorScheme.light()
                        ? Colors.black
                        : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
      ],
    );
  }

  void GetNewOfferClicked(BuildContext context) async {
    await facilityController.GetNewOffer();
  }

  Future<void> RefreshFacilityName() async {
    await facilityController.RefreshScreen();
  }

  void AddNewJopOfferPost(BuildContext context) {
    AddAndEditPost AddNewJopOfferPost = AddAndEditPost(
      context: context,
      facilityName: facilityController.facilityInformation.name,
      facilityImage: facilityController.facilityInformation.photo,
    );

    AddNewJopOfferPost.NewAddAndEditPost(() {
      if (PostType[AddNewJopOfferPost.IndexOfTypeAddPostJopOrOffer + 1] ==
          'Job') {
        AddNewJopPost(context, AddNewJopOfferPost);
      } else if (PostType[
              AddNewJopOfferPost.IndexOfTypeAddPostJopOrOffer + 1] ==
          'Offer') {
        AddNewOfferPost(context, AddNewJopOfferPost);
      }
    });
  }

  void AddNewJopPost(
      BuildContext context, AddAndEditPost AddNewJopOfferPost) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    if (AddNewJopOfferPost.postTitle == null) {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_title_is_required}',
          true);
    }
    if (AddNewJopOfferPost.postDescription == null) {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_description_is_required}',
          true);
    }
    facilityController.PostTitle = AddNewJopOfferPost.postTitle!;
    facilityController.PostDescription = AddNewJopOfferPost.postDescription!;
    if (AddNewJopOfferPost.NewLoadImage != null)
      facilityController.PostImageFile =
          File(AddNewJopOfferPost.NewLoadImage!.path);
    if (AddNewJopOfferPost.NewLoadVideo != null)
      facilityController.PostVideoFile =
          File(AddNewJopOfferPost.NewLoadVideo!.path);
    await facilityController.AddTheNewJop(context);
    if (facilityController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          false);
      await RefreshFacilityName();
      Navigator.of(context).pop();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
    }
    facilityController.PostImageFile = null;
    facilityController.PostVideoFile = null;
  }

  void SendEditingJopPost(
      BuildContext context, AddAndEditPost EditPost, int PostId) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    if (EditPost.postTitle == '') {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_title_is_required}',
          true);
    }
    if (EditPost.postDescription == '') {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_description_is_required}',
          true);
    }

    if (EditPost.NewLoadImage != null) {
      facilityController.PostImageFile = File(EditPost.NewLoadImage!.path);
    }

    if (EditPost.NewLoadVideo != null)
      facilityController.PostVideoFile = File(EditPost.NewLoadVideo!.path);
    facilityController.PostTitle = EditPost.postTitle!;
    facilityController.PostDescription = EditPost.postDescription!;
    facilityController.PostId = PostId;
    await facilityController.SendEditJopPost(context);
    if (facilityController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
      Navigator.of(context).pop();
      await RefreshFacilityName();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
    }
    facilityController.PostImageFile = null;
    facilityController.PostVideoFile = null;
  }

  void DeleteJopPost(BuildContext context, int PostId, int index) {
    SureQuestionAlert(() {
      SendDeletedJopPost(context, PostId, index);
    }, context);
  }

  void SendDeletedJopPost(BuildContext context, int PostId, int index) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    facilityController.PostId = PostId;
    await facilityController.SendDeleteJop(context);
    if (facilityController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
      Navigator.of(context).pop();
      await RefreshFacilityName();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
      Navigator.of(context).pop();
    }
  }

  void AddNewOfferPost(
      BuildContext context, AddAndEditPost AddNewJopOfferPost) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    if (AddNewJopOfferPost.postTitle == null) {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_title_is_required}',
          true);
    }
    if (AddNewJopOfferPost.postDescription == null) {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_description_is_required}',
          true);
    }
    facilityController.PostTitle = AddNewJopOfferPost.postTitle!;
    facilityController.PostDescription = AddNewJopOfferPost.postDescription!;
    if (AddNewJopOfferPost.NewLoadImage != null)
      facilityController.PostImageFile =
          File(AddNewJopOfferPost.NewLoadImage!.path);
    if (AddNewJopOfferPost.NewLoadVideo != null)
      facilityController.PostVideoFile =
          File(AddNewJopOfferPost.NewLoadVideo!.path);
    await facilityController.AddTheNewOffer(context);
    if (facilityController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          false);
      Navigator.of(context).pop();
      await RefreshFacilityName();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
    }
    facilityController.PostImageFile = null;
    facilityController.PostVideoFile = null;
  }

  void SendEditingOfferPost(
      BuildContext context, AddAndEditPost EditPost, int PostId) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    if (EditPost.postTitle == '') {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_title_is_required}',
          true);
    }
    if (EditPost.postDescription == '') {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.post_description_is_required}',
          true);
    }

    if (EditPost.NewLoadImage != null) {
      facilityController.PostImageFile = File(EditPost.NewLoadImage!.path);
    }

    if (EditPost.NewLoadVideo != null)
      facilityController.PostVideoFile = File(EditPost.NewLoadVideo!.path);
    facilityController.PostTitle = EditPost.postTitle!;
    facilityController.PostDescription = EditPost.postDescription!;
    facilityController.PostId = PostId;
    await facilityController.SendEditOfferPost(context);
    if (facilityController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
      Navigator.of(context).pop();
      await RefreshFacilityName();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
    }
    facilityController.PostImageFile = null;
    facilityController.PostVideoFile = null;
  }

  void DeleteOfferPost(BuildContext context, int PostId, int index) {
    SureQuestionAlert(() {
      SendDeletedOfferPost(context, PostId, index);
    }, context);
  }

  void SendDeletedOfferPost(BuildContext context, int PostId, int index) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    facilityController.PostId = PostId;
    await facilityController.SendDeleteOffer(context);
    if (facilityController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
      Navigator.of(context).pop();
      await RefreshFacilityName();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
      Navigator.of(context).pop();
    }
  }

  Future<bool> FollowAndUnfollowTheFoundation(BuildContext context) async {
    if (!facilityController.UserFollowTheFoundation) {
      await facilityController.FollowTheFoundation(context);
      if (facilityController.State) {
        facilityController.UserFollowTheFoundation = true;
      } else {
        loadingMessage.DisplayError(
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            facilityController.Message,
            true);
      }
    } else {
      await facilityController.UnFollowTheFoundation(context);
      if (facilityController.State) {
        facilityController.UserFollowTheFoundation = false;
      } else {
        loadingMessage.DisplayError(
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            facilityController.Message,
            true);
      }
    }
    return true;
  }

  void GoToFacilityUserChat(BuildContext context)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );

    await facilityController.StartChating(context);

    if(facilityController.State){
      loadingMessage.Dismiss();
      Get.toNamed('/chat_messages',arguments: {'chat_id':facilityController.ChatWithFoundationId,'User_name':facilityController.facilityInformation.name,'user_image':facilityController.facilityInformation.photo,'IsFoundation':0,'Chat_is_blocked':false});
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityController.Message,
          true);
    }
  }
}
