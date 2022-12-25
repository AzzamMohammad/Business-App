import 'package:business_01/components/loading/loding_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../all_facility-for_owner_drawer/all_facility_for_owner_drawer.dart';
import '../../components/bottom_bar.dart';
import '../../components/cach_image_from_network.dart';
import '../../components/get_date_of_message.dart';
import '../../components/loading/loading_members.dart';
import '../../components/my_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../components/setting_drawer.dart';
import '../../components/sure_question_alert.dart';
import 'all_chat_controller.dart';

class AllChatScreen extends StatelessWidget {
  final AllChatController allChatController = Get.find();
  final LoadingMessage loadingMessage = LoadingMessage();
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
        if(allChatController.ChatsListController.position.pixels == 0){
          if(allChatController.IsFacility == 0)
            Get.offAllNamed('/home_page');
          return true;
        }else{
          allChatController.ChatsListController.animateTo(0,duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          return false;
        }
      },
      child: Scaffold(
        endDrawer: BuildSettingDrawer(context),
        drawer:allChatController.IsFacility==0? BuildAllFacilityForOwner(context):null,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Chat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            Container()
          ],
          automaticallyImplyLeading:allChatController.IsFacility==0? false:true,
          // leadingWidth: 30,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              RefreshTheScreen();
            },
            color: Color(0xff076579),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: allChatController.ChatsListController,
              child: Obx(() {
                if (allChatController.IsLoaded.value) {
                  if (allChatController.NumberOfChatsInList.value == 0) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .4),
                          child: Center(
                            child: Text('${AppLocalizations.of(context)!.no_data_to_display}'),
                          ),
                        )
                      ],

                    );
                  } else {

                    return ListView.builder(
                      itemCount: allChatController.NumberOfChatsInList.value + 1,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context,index){
                        if(index < allChatController.NumberOfChatsInList.value){
                          return BuildChatCard(context,index);
                        }else{
                          if(!allChatController.ArrivedToLastChat){
                            return LoadingMemberOfList(context);
                          }
                          return Container();
                        }
                      },
                    );
                  }
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoadingMemberOfList(context),
                );
              }),
            ),
          ),
        ),
        bottomNavigationBar:allChatController.IsFacility == 0? BuildBottomBar(context, 1,_scaffoldKey):Container(width: 0,height: 0,),
      ),
    );
  }

  Widget BuildChatCard(BuildContext context, int index) {
    // allChatController.ChatIsBlocked(allChatController.ChatsList[index].isBlocked);
    return GestureDetector(
      onTap: (){
        GoToChat(allChatController.ChatsList[index].id,allChatController.ChatsList[index].name,allChatController.ChatsList[index].foundationPhoto,allChatController.ChatsList[index].isBlocked);
      },
      child:  Container(
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        height: 90,
        decoration: /*(!allChatController.ChatIsBlocked.value)*/(!allChatController.ChatsList[index].isBlocked) && allChatController.ChatsList[index].lastMessageIsRead == 0 ?  BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme == ColorScheme.light()
              ? Color(0xffececec)
              : Color(0xff111111),
        ):BoxDecoration(),
        child: ListTile(
          dense: false,
          contentPadding: EdgeInsets.all(7),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                image:allChatController.ChatsList[index].foundationPhoto == null ? DecorationImage(
                    image: AssetImage('assets/images/sss.jpg'),
                    fit: BoxFit.cover):
                DecorationImage(
                  image:GetAndCacheNetworkImageProvider(
                      allChatController.ChatsList[index].foundationPhoto),
                  onError: (err,dd){
                    print(err);
                  },

                  fit: BoxFit.cover,
                )),
          ),
          title: Text(
            allChatController.ChatsList[index].name,
            style: TextStyle(fontSize: 17, color: Color(0xff076579)),
          ),
          subtitle:/*allChatController.ChatIsBlocked.value == false*/!allChatController.ChatsList[index].isBlocked ? (allChatController.ChatsList[index].lastMessage != null ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  allChatController.ChatsList[index].lastMessage,
                  style:
                  TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                  maxLines: 1,
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                  GetDateOfMessage(allChatController.ChatsList[index].createdLastMessage),
                  style: TextStyle(
                      fontSize: 14, overflow: TextOverflow.ellipsis),
                  maxLines: 1,
                ),
              ),
            ],
          ) : Text('No message yet..')):Text('Blocked',style: TextStyle(color: Colors.red),),
          trailing: PopupMenuButton<Widget>(
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
              /*!allChatController.ChatIsBlocked.value*/ !allChatController.ChatsList[index].isBlocked ? PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Block',
                      style: TextStyle(),
                    ),
                    Icon(
                      Icons.block,
                    ),
                  ],
                ),
                onTap: () {
                  BlockTheChatClicked(context , allChatController.ChatsList[index].id);
                },
              ):PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Unblock',
                      style: TextStyle(),
                    ),
                    Icon(
                      Icons.block,
                    ),
                  ],
                ),
                onTap: () {
                  UnBlockTheChatClicked(context , allChatController.ChatsList[index].id);
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
                          DeleteTheChatClicked(context , allChatController.ChatsList[index].id , index)
                  );

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void BlockTheChatClicked(BuildContext context , int index) async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allChatController.BlockTheChat(context , index);

    if (allChatController.State) {
      // allChatController.ChatIsBlocked(true);
      RefreshTheScreen();
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allChatController.Message,
          true);
    }
    else {
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
          allChatController.Message,
          true);
    }
  }


  void UnBlockTheChatClicked(BuildContext context , int index) async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allChatController.UnBlockTheChat(context , index);

    if (allChatController.State) {
      // allChatController.ChatIsBlocked(false);
      RefreshTheScreen();
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allChatController.Message,
          true);
    }
    else {
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
          allChatController.Message,
          true);
    }
  }
  void DeleteTheChatClicked(BuildContext context , int ChatIndex , int ChatIndexInList){
    SureQuestionAlert(() {
      SendDeleteTheChatClicked(context , ChatIndex ,ChatIndexInList );
    }, context);
  }


  void SendDeleteTheChatClicked(BuildContext context , int ChatIndex , int ChatIndexInList) async{
    Navigator.of(context).pop();
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allChatController.DeleteTheChat(context , ChatIndex);

    if (allChatController.State) {
      allChatController.ChatsList.removeAt(ChatIndexInList);
      allChatController.NumberOfChatsInList(allChatController.ChatsList.length);
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allChatController.Message,
          true);
    }
    else {
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
          allChatController.Message,
          true);
    }

  }

  Future<void> RefreshTheScreen()async {
    await allChatController.RefreshAllChatScreen();
  }

  void GoToChat(int ChatId , String UserName , String? ImageUrl,bool IsBlock){
    Get.toNamed('/chat_messages',arguments: {'chat_id':ChatId,'User_name':UserName,'user_image':ImageUrl,'IsFoundation':allChatController.IsFacility,'Chat_is_blocked': IsBlock});
  }

}
