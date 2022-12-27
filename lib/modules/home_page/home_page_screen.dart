import 'package:business_01/components/my_divider.dart';
import 'package:business_01/modules/home_page/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';
import '../all_facility-for_owner_drawer/all_facility_for_owner_drawer.dart';
import '../../components/cach_image_from_network.dart';
import '../../components/loading/loading_admin_post.dart';
import '../../components/loading/loading_following_image.dart';
import '../../components/loading/loading_posts_list.dart';
import '../../components/post/post_card.dart';
import '../../components/bottom_bar.dart';
import '../../components/loading/loding_message.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../components/setting_drawer.dart';


class HomePageScreen extends StatelessWidget {
  final HomePageController homePageController = Get.find();
  DateTime timeBackButtonPressed = DateTime.now();
  final LoadingMessage loadingMessage = LoadingMessage();
  int InitAdminPostsPage = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_scaffoldKey.currentState!.isDrawerOpen){
          _scaffoldKey.currentState!.closeDrawer();
          return false;
        }

        if(_scaffoldKey.currentState!.isEndDrawerOpen){
          _scaffoldKey.currentState!.closeEndDrawer();
          return false;
        }
        if(homePageController.FacilityPostsScrollController.position.pixels == 0){
          final Difference = DateTime.now().difference(timeBackButtonPressed);
          timeBackButtonPressed = DateTime.now();
          if (Difference >= Duration(seconds: 2)) {
            loadingMessage.DisplayToast(
                Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                Theme
                    .of(context)
                    .primaryColor,
                Theme
                    .of(context)
                    .primaryColor,
                '${AppLocalizations.of(context)!.press_back_again_to_exit}',
                true);
            return false;
          } else {
            loadingMessage.Dismiss();
            return true;
          }
        }
        else{
          homePageController.FacilityPostsScrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
          return false;
        }
      },
      child: Scaffold(
        endDrawer: BuildSettingDrawer(context),
        key:_scaffoldKey ,
        drawer: BuildAllFacilityForOwner(context),
        appBar: AppBar(
          title: Text("${AppLocalizations.of(context)!.home}"),
          actions: [
            Container()
          ],
         automaticallyImplyLeading: false,
          leadingWidth: 30,
        ),
        // backgroundColor: Colors.blue,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: ()async{
                  RefreshHomePage();
                },
                color: Color(0xff076579),
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  controller: homePageController.FacilityPostsScrollController,
                  children: [
                    Obx(() {
                      return CarouselSlider.builder(
                          options: CarouselOptions(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .4,
                            // enableInfiniteScroll: !homePageController.ArrivedToAdminPostsListEnd ? false : true,
                            autoPlay: true,
                            autoPlayAnimationDuration: Duration(seconds:2),
                            initialPage: InitAdminPostsPage,
                            autoPlayInterval: Duration(seconds: 15),
                            autoPlayCurve: Curves.easeInOut,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                          ),
                          itemCount: !homePageController.ArrivedToAdminPostsListEnd ?  homePageController.NumberOfAdminPostsList
                              .value + 1 :  homePageController.NumberOfAdminPostsList
                              .value,
                          itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) {
                            if (itemIndex <
                                homePageController.NumberOfAdminPostsList.value) {
                              var IsOpen = false.obs;
                              print('index : ${itemIndex}');
                              print(homePageController.NumberOfAdminPostsList.value);
                              InitAdminPostsPage = itemIndex-1;
                              return AdminPostCard(itemIndex, context, IsOpen);
                            } else {
                              if (!homePageController
                                  .ArrivedToAdminPostsListEnd) {
                                print('ffffffffffffffffff');
                                GetNewAdminPost();
                                return LoadingAdminPost(context);
                              }
                              return Container();
                            }
                          }
                      );
                    }),
                    MyDivider(context, 2),
                    SizedBox(
                      height: 150,
                      child:Obx((){
                        if(homePageController.IsLoadFacilityFollowList.value){
                          if(homePageController.NumberOfFacilityFollowList.value == 0){
                            return BuildAddNewFollow(context);
                          }else{
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(top: 10),
                              controller: homePageController
                                  .FacilityFollowListScrollController,
                              itemCount: homePageController
                                  .NumberOfFacilityFollowList.value +
                                  1,
                              itemBuilder: (context, index) {
                                if (index <
                                    homePageController
                                        .NumberOfFacilityFollowList.value) {
                                  return FacilityFollowCard(index);
                                } else {
                                  if (!homePageController
                                      .ArrivedToFacilityFollowListEnd)
                                    return LoadingFollowList(context);
                                  return Container();
                                }
                              },
                            );
                          }
                        }
                        else
                          return LoadingFollowList(context);
                      }),
                    ),
                    // Expanded(child: ),
                    Obx(() {
                      return ListView.builder(
                        // padding: EdgeInsets.only(top: 20),
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: homePageController.NumberOfFacilityPostsList
                            .value +
                            1,
                        primary: false,
                        // controller:
                        // homePageController.FacilityPostsScrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index <
                              homePageController.NumberOfFacilityPostsList
                                  .value) {
                            return FacilityPostCard(context, index);
                          } else {
                            if (!homePageController
                                .ArrivedToFacilityPostsListEnd)
                              return LoadingPostList(context);
                            return Container();
                          }
                        },
                      );
                    }),
                  ],
                ),
              )),
        ),
        bottomNavigationBar: BuildBottomBar(context, 2,_scaffoldKey),
      ),
    );
  }

  Widget AdminPostCard(int index, BuildContext context, var IsOpen) {
    return Obx((){
      return GestureDetector(
        onTap: (){
          IsOpen(!IsOpen.value);
        },
        child: Container(
          margin: EdgeInsets.all(4),
          width: MediaQuery
              .of(context)
              .size
              .width * .9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
              image: GetAndCacheNetworkImageProvider(homePageController.AdminPostsList[index].photo),
              onError: (err,dd){
                print(err);
              },


            ),
          ),
          child: Stack(
            children: [
              AnimatedOpacity(
                  opacity: IsOpen.value ? 1 : 0,
                  duration: Duration(milliseconds: 600),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints box) {
                      return Container(
                        width: box.maxWidth,
                        height: box.maxHeight,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 100,),
                            Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(left: 20 , right: 15,top: 5),
                                  child: Text(homePageController.AdminPostsList[index].description,style: TextStyle(color: Colors.white , fontSize: 16),),
                                ),
                            ),
                          ],
                        ),
                      );
                    },

                  )
              ),
              AnimatedAlign(
                alignment: IsOpen.value ? Alignment.topCenter : Alignment.bottomCenter,
                duration: Duration(milliseconds: 400),

                child:LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                    return Container(
                      width: box.maxWidth,
                      height: IsOpen.value ? 100 : 70,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child:  Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap:(){
                              Get.toNamed('/facility', arguments: {
                                'facility_id': homePageController.AdminPostsList[index].foundationId,
                                'is_user': true
                              });
                            },
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  image: DecorationImage(
                                    image:GetAndCacheNetworkImageProvider(
                                        homePageController.AdminPostsList[index].foundationPhoto),
                                    onError: (err,dd){
                                      print(err);
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: null),
                          ),
                          title: GestureDetector(
                            onTap:(){
                              Get.toNamed('/facility', arguments: {
                                'facility_id': homePageController.AdminPostsList[index].foundationId,
                                'is_user': true
                              });
                            },
                            child: Text(
                              "${homePageController.AdminPostsList[index].foundationName}",
                              style: TextStyle(fontSize: 19,color: Color(
                                  0xff02c2e8)),
                            ),
                          ),
                          subtitle: Text(
                            homePageController.AdminPostsList[index].title,
                            style: TextStyle(color: Colors.white , fontSize: 15 , fontWeight: FontWeight.bold ),
                            maxLines:IsOpen.value ? 2 : 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget FacilityFollowCard(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/facility', arguments: {
          'facility_id': homePageController.FacilityFollowList[index].id,
          'is_user': true
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
          width: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Color(0xff076579)),
                  borderRadius: BorderRadius.all(Radius.circular(120)),
                ),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(110)),
                    image: DecorationImage(
                      image: GetAndCacheNetworkImageProvider(homePageController.FacilityFollowList[index].photo),
                      onError: (err,dd){
                        print(err);
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(
                homePageController.FacilityFollowList[index].name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildAddNewFollow(BuildContext context){
    return GestureDetector(
      onTap: () {
        Get.toNamed('/search');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            width:120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Color(0xff076579)),
                    borderRadius: BorderRadius.all(Radius.circular(120)),
                  ),
                  child: Center(child: Icon(Icons.add)),
                ),
                Text(
                  'Starting facilities follow',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget LoadingFollowList(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LoadingFollowingImage(context),
      ],
    );
  }


  Widget FacilityPostCard(BuildContext context, int index) {
    return PostListTile(
      context,
      true,
      homePageController.FacilityPosts[index].foundationPhoto,
      homePageController.FacilityPosts[index].foundationName,
      homePageController.FacilityPosts[index].createdAt,
      homePageController.FacilityPosts[index].title,
      homePageController.FacilityPosts[index].description,
      homePageController.FacilityPosts[index].photo ==
          null
          ? ""
          : homePageController.FacilityPosts[index].photo !,
          (context) => [],
      homePageController.FacilityPosts[index].foundationId,
    );
  }

  void GetNewAdminPost() {
    homePageController.GetNewAdminPostsListItem();
  }

  void RefreshHomePage(){
    homePageController.RefreshPage();
  }

}

