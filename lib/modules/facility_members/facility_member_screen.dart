import 'dart:io';

import 'package:business_01/modules/facility_members/facility_member_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../components/cach_image_from_network.dart';
import '../../components/loading/loading_members.dart';
import '../../components/loading/loding_message.dart';
import '../../components/member_card.dart';
import '../../components/my_divider.dart';

class FacilityMembersScreen extends StatelessWidget {
  final FacilityMemberController facilityMemberController = Get.find();
  final LoadingMessage loadingMessage = LoadingMessage();
  final ScrollDown = true.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(facilityMemberController.NumberOfMembersInList.value == 0)
          return true;
        if (facilityMemberController.MemberListController.position.pixels == 0)
          return true;
        else {
          facilityMemberController.MemberListController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Members',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          automaticallyImplyLeading: true,
          // leadingWidth: 30,
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: RefreshIndicator(
            onRefresh: () async {
              RefreshList();
            },
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.forward) {
                  if (!ScrollDown.value) ScrollDown(false);
                }
                if (notification.direction == ScrollDirection.reverse) {
                  if (ScrollDown.value) ScrollDown(true);
                }
                return true;
              },
              child: Obx(() {
                if (facilityMemberController.IsLoaded.value) {
                  if (facilityMemberController.FacilityMember.length == 0) {
                    return Center(
                      child: Text('No Member'),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 5),
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount:
                          facilityMemberController.NumberOfMembersInList.value +
                              1,
                      controller: facilityMemberController.MemberListController,
                      itemBuilder: (context, index) {
                        if (index <
                            facilityMemberController
                                .NumberOfMembersInList.value) {
                          var OpenTitle = false.obs;
                          var OpenDescription = false.obs;
                          return MemberCard(
                              context,
                              OpenTitle,
                              OpenDescription,
                              facilityMemberController
                                  .FacilityMember[index].name,
                              facilityMemberController
                                  .FacilityMember[index].description,
                              facilityMemberController
                                  .FacilityMember[index].photo,
                              facilityMemberController.FacilityMember[index].id,
                            index
                          );
                        } else {
                          if (!facilityMemberController
                              .ArrivedToEndOfListMember)
                            return LoadingMemberOfList(context);
                          return Container();
                        }
                      },
                    );
                  }
                } else
                  return LoadingMemberOfList(context);
              }),
            ),
          ),
        )),
        floatingActionButton:!facilityMemberController.IsUser? Obx(() {
          if (ScrollDown.value)
            return AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
                width: 150,
                height: 50,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    AddNewMember(context);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    '${AppLocalizations.of(context)!.new_member}',
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
                AddNewMember(context);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Color(0xff076579),
            ),
          );
        }):null,
      ),
    );
  }

  Widget MemberCard(BuildContext context, var OpenTitle, var OpenDescription,
      String MemberName, String MemberDescription, String? MemberImage,int MemberId,int Index) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
                  // height: 100,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.all(Radius.circular(8)),
                  //   color:
                  //   Theme.of(context).colorScheme == ColorScheme.light()
                  //       ? Color(0xffececec)
                  //       : Color(0xff111111),
                  // ),
          child: ListTile(

            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(140)),
                  border: Border.all(width: 3, color: Color(0xff076579))),
              child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(130)),
                      image: DecorationImage(
                        onError: (err,dd){
                          print(err);
                          },
                          image: MemberImage != null ?GetAndCacheNetworkImageProvider(MemberImage
                          ) : AssetImage('assets/images/sss.jpg'), fit: BoxFit.cover),
                      color: Theme.of(context).colorScheme == ColorScheme.light()
                          ? Color(0xfff8f8f8)
                          : Color(0xff0a0a0a),
                    ),
                  )),
            ),

            title: Obx(() {
              return GestureDetector(
                onTap: () {
                  OpenTitle(!OpenTitle.value);
                },
                child: Text(
                  '${MemberName}',
                  maxLines: OpenTitle.value ? 100 : 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xff076579)),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
            subtitle: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      OpenDescription(!OpenDescription.value);
                    },
                    child: Text(
                      '${MemberDescription}',
                      maxLines: OpenDescription.value ? 100 : 2,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              );
            }),
            trailing:!facilityMemberController.IsUser? PopupMenuButton<Widget>(
              position: PopupMenuPosition.over,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .4,
                minWidth: MediaQuery.of(context).size.width * .4,
              ),
              color: Theme.of(context).colorScheme == ColorScheme.light()
                  ? Color(0xffefefef)
                  : Color(0xff1a1a1a),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${AppLocalizations.of(context)!.update}'),
                      Icon(Icons.update,color:Color(0xffc2c2c2) ,),
                    ],
                  ),
                  onTap: () {
                    AddAndEditMembers EditMember = AddAndEditMembers(
                        context: context,
                      memberName: MemberName,
                      memberImage: MemberImage,
                      memberDescription: MemberDescription,
                      cardType: '${MemberName}'
                        );

                    Future.delayed(
                        Duration(seconds: 0),
                            () async =>
                                EditMember.NewAddAndEditMember(() {
                                  SendEditMember(
                                      context, EditMember,
                                      MemberId);
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
                            DeleteMember(
                                context, MemberId,Index)
                    );
                  },
                ),
              ],
            ):null,
          ),
        ),
    SizedBox(
          height: 10,
        )
      ],
    );

  }

  void AddNewMember(BuildContext context) async {
    AddAndEditMembers AddMember =
    AddAndEditMembers(context: context, cardType: '${AppLocalizations.of(context)!.add_member}');
    AddMember.NewAddAndEditMember(() {
      SendNewMemberToAdd(context, AddMember);
    });
  }

  void SendNewMemberToAdd(BuildContext context, AddAndEditMembers NewMember) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    if (NewMember.memberName == null) {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.member_name_is_required}',
          true);
    }
    if (NewMember.memberDescription == null) {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          '${AppLocalizations.of(context)!.member_description_is_required}',
          true);
    }
    facilityMemberController.MemberName = NewMember.memberName!;
    facilityMemberController.MemberDescription = NewMember.memberDescription!;
    if (NewMember.NewLoadImage != null)
      facilityMemberController.MemberImage = File(NewMember.NewLoadImage!.path);
    await facilityMemberController.SendNewMember(context);
    if (facilityMemberController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityMemberController.Message,
          true);
      await RefreshList();
      Navigator.of(context).pop();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          facilityMemberController.Message,
          true);
    }
    facilityMemberController.MemberImage = null;
  }

  Future<void> RefreshList()async {
     facilityMemberController.RefreshMemberList();
  }

  void SendEditMember(BuildContext context , AddAndEditMembers EditMember , int MemberId) async {
    loadingMessage.DisplayLoading(
      Theme
          .of(context)
          .scaffoldBackgroundColor,
      Theme
          .of(context)
          .primaryColor,
    );
    if (EditMember.memberName == '') {
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
          '${AppLocalizations.of(context)!.member_name_is_required}',
          true);
    }
    if (EditMember.memberDescription == '') {
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
          '${AppLocalizations.of(context)!.member_description_is_required}',
          true);
    }


    facilityMemberController.MemberName = EditMember.memberName!;
    facilityMemberController.MemberId = MemberId;
    facilityMemberController.MemberDescription = EditMember.memberDescription!;
    if (EditMember.NewLoadImage != null)
      facilityMemberController.MemberImage = File(EditMember.NewLoadImage!.path);
    await facilityMemberController.SendEditMember(context);
    if (facilityMemberController.State) {
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
          facilityMemberController.Message,
          true);
     await RefreshList();
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
          facilityMemberController.Message,
          true);
    }
    facilityMemberController.MemberImage = null;

  }

  void DeleteMember(BuildContext context, int MemberId , int index) async {
    loadingMessage.DisplayLoading(
      Theme
          .of(context)
          .scaffoldBackgroundColor,
      Theme
          .of(context)
          .primaryColor,
    );
    facilityMemberController.MemberId = MemberId;
    await facilityMemberController.SendDeletePost(context);
    if (facilityMemberController.State) {
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
          facilityMemberController.Message,
          true);
      await RefreshList();
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
          facilityMemberController.Message,
          true);
    }
  }
}
