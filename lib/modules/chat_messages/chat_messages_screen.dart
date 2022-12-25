import 'package:better_video_player/better_video_player.dart';
import 'package:business_01/components/my_divider.dart';
import 'package:business_01/modules/chat_messages/chat_messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../components/cach_image_from_network.dart';
import '../../components/build_video_widget.dart';
import '../../components/get_message_time.dart';
import '../../components/image_and_video_picker.dart';
import '../../components/loading/loading_message_chat.dart';
import '../../components/loading/loding_message.dart';

class ChatMessagesScreen extends StatelessWidget {
  final ChatMessagesController chatMessagesController = Get.find();
  final LoadingNewImageOrVideo = false.obs;
  final LoadingMessage loadingMessage = LoadingMessage();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title:Row(
          children: [
      Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            image: chatMessagesController.UserImageUrl == null? DecorationImage(
                image: AssetImage('assets/images/sss.jpg'),
                fit: BoxFit.cover):
            DecorationImage(
              image:GetAndCacheNetworkImageProvider(
                  chatMessagesController.UserImageUrl!),
              onError: (err,dd){
                print(err);
              },
              fit: BoxFit.cover,
            )),
      ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Text(
                '${chatMessagesController.UserName}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<Widget>(
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
              !chatMessagesController.ChatIsBlocked.value ? PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Block',
                      style: TextStyle(),
                    ),
                    Icon(
                      Icons.block,
                      color: Theme.of(context).colorScheme == ColorScheme.light()
                          ? Color(0xff1a1a1a)
                          : Color(0xffefefef),
                      size: 25,
                    ),
                  ],
                ),
                onTap: () {
                  BlockTheChatClicked(context , chatMessagesController.ChatId);
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
                      color: Theme.of(context).colorScheme == ColorScheme.light()
                          ? Color(0xff1a1a1a)
                          : Color(0xffefefef),
                      size: 25,
                    ),
                  ],
                ),
                onTap: () {
                  UnBlockTheChatClicked(context , chatMessagesController.ChatId);
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
                      size: 25,
                    )
                  ],
                ),
                onTap: () {
                  Future.delayed(
                      Duration(seconds: 0),
                          () async =>
                          DeleteTheChatClicked(context , chatMessagesController.ChatId )
                  );

                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(child: Obx(() {
        if (chatMessagesController.IsLoaded.value) {
          return Column(
            children: [
              Obx((){
                return   Expanded(
                  child: ListView.builder(
                    controller: chatMessagesController.MessageListController,
                    reverse: true,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: chatMessagesController.NumberOfMessagesInList.value+1,
                    itemBuilder: (context, index) {
                      if(index < chatMessagesController.NumberOfMessagesInList.value ){
                        if(chatMessagesController.ChatMessagesList[index].isFoundation == chatMessagesController.IsFoundation)//the type of app user witch come from all chat screen((IsUser))
                          return BuildMessageCart(context , index  , true);
                        else
                          return BuildMessageCart(context , index  , false);
                      }
                      else if(!chatMessagesController.ArrivedToEndOfList)
                        return LoadingMessageChat(context);
                      else
                        return Container();
                    },
                  ),
                );
              }),
              MyDivider(context, 1),
              Obx((){
                return  chatMessagesController.CommentMessage.value != 1000000000000 ?BuildCommentMessageBarBeforeSend(context,chatMessagesController.CommentMessage.value)
                    :Container();
              }),
              Obx((){
                return  LoadingNewImageOrVideo.value ?
                BuildSendVideoOrImageBar(context):
                Container();
              }),
              chatMessagesController.ChatIsBlocked.value ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('You can not send to this person ^_^ !')
                ],
              ) : BuildSendBar(context)
            ],
          );
        } else {
          return LoadingMessageChat(context);
        }
      })),
    );
  }

  Widget BuildMessageCart(BuildContext context, int index, bool IsMainUser) {

    return Draggable(
      onDragEnd: (dd){
        chatMessagesController.CommentMessage(index);
        chatMessagesController.IdOfCommentMessage = chatMessagesController.ChatMessagesList[index].id;
      },

      axis:Axis.horizontal,
      childWhenDragging: Visibility(
        visible: false,
        maintainSize: true,
        maintainAnimation: true,
        maintainSemantics: true,
        maintainInteractivity: true,
        maintainState: true,
        child: Message(context,index,IsMainUser) ,
      ) ,
      feedback: Message(context,index,IsMainUser) ,
      child: Message(context,index,IsMainUser) ,
    );
  }

  Widget Message(BuildContext context , int index, bool IsMainUser){
    Color UserColor = Theme.of(context).colorScheme ==
        ColorScheme.light()
        ? Colors.blueAccent
        : Colors.blueAccent.shade700;
    Color SenderColor =Theme.of(context).colorScheme ==
        ColorScheme.light()
        ? Color(0xff9a9a9a)
        : Color(0xff1e1e1e);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 8, right: 8,bottom: 8),
      child: Row(
        mainAxisAlignment:
        IsMainUser ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment:
            IsMainUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              chatMessagesController.ChatMessagesList[index].messageTextReplay!=null?
              Padding(
                padding: chatMessagesController.ChatMessagesList[index].messageTextReplay==null? EdgeInsets.all(0):EdgeInsets.only(left: 10 , right: 10),
                child: Container(
                  padding: EdgeInsets.all( 10),
                  // width: MediaQuery.of(context).size.width * .6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: IsMainUser ? Color(0xff868888) : Colors.blueAccent.shade700,
                  ),

                  child: MessageContent(context,
                      chatMessagesController.ChatMessagesList[index].messagePhotoReplay,
                      chatMessagesController.ChatMessagesList[index].messageVideoReplay,
                      null,
                      chatMessagesController.ChatMessagesList[index].messageTextReplay
                  ),
                ),
              ):Container(),
              Row(

                textDirection:rtlLanguages.contains(Get.locale?.languageCode) ? (IsMainUser? TextDirection.rtl:TextDirection.ltr) : IsMainUser? TextDirection.ltr:TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    return  Container(
                      padding: EdgeInsets.all(10),
                      // width: MediaQuery.of(context).size.width * .6,
                      decoration: BoxDecoration(
                        color:chatMessagesController.ChatMessagesList[index].MessageState != 'failed'? ( IsMainUser? SenderColor : UserColor) : (IsMainUser ? Color(0xff868888) : Colors.blueAccent.shade700),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MessageContent(context,
                          chatMessagesController.ChatMessagesList[index].photo,
                          chatMessagesController.ChatMessagesList[index].video,
                          chatMessagesController.ChatMessagesList[index].betterVideoPlayerController,
                          chatMessagesController.ChatMessagesList[index].message
                      ),
                    );
                  }),
                  IsMainUser?  Column(
                    children: [
                      if (chatMessagesController.ChatMessagesList[index].MessageState == 'arrive' ||chatMessagesController.ChatMessagesList[index].MessageState == 'read')
                        PopupMenuButton<Widget>(
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(

                            Icons.more_vert,

                            ),
                          ),
                        position: PopupMenuPosition.under,
                          iconSize: 15,
                          constraints: BoxConstraints(
                            maxWidth: 100,
                            minWidth: 100,
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
                              height: 10,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.delete}',
                                    style: TextStyle(fontSize: 13,color: Colors.red),
                                  ),
                                  Icon(
                                    Icons.delete,
                                    size: 15,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Future.delayed(
                                    Duration(seconds: 0),
                                        ()  => DeleteMessage(chatMessagesController.ChatMessagesList[index].id , index));

                              },
                            ),
                          ]) else Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8 , right: 8, bottom: 3),
                        child: Obx((){
                          if (chatMessagesController.ChatMessagesList[index].MessageState == 'sending') {
                            return Icon(Icons.watch_later_outlined ,size: 15,);
                          } else {
                            return (chatMessagesController.ChatMessagesList[index].MessageState == 'failed'?GestureDetector(onTap:(){ReSendMessage(index);},child: Icon(Icons.refresh , size: 15,color: Colors.red,)):
                          (chatMessagesController.ChatMessagesList[index].MessageState == 'arrive'?Icon(Icons.done, size: 15) : chatMessagesController.ChatMessagesList[index].MessageState == 'read'? Icon(Icons.done_all ,size: 15 , color: Colors.blueAccent,):Container()));
                          }
                        }),
                      ),
                    ],
                  ):Container(),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Text(
                  GetMessageTime(chatMessagesController.ChatMessagesList[index].createdAt),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget MessageContent(BuildContext context , dynamic image ,dynamic video,BetterVideoPlayerController? betterVideoPlayerController , dynamic MessageText){
   var DisplayVideo = false.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        image != null?
        Container(
            width: MediaQuery.of(context).size.width * .58,
            height: 150,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image:GetAndCacheNetworkImageProvider(
                      image),
                  onError: (err,dd){
                    print(err);
                  },
                  fit: BoxFit.cover,
                )
            )
        ):Container(),
        video != null ?(
        Obx((){
          if(DisplayVideo.value){
            return BuildVideoNetworkWidget(
                context,
                video,
                betterVideoPlayerController
            );
          }
          else{
            return GestureDetector(
              onTap: (){
               DisplayVideo(true);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * .58,
                  height: 150,
                  color: Colors.black,
                  child: Center(
                    child: Icon(Icons.play_circle_outline,size: 60,),
                  )




              ),
            );
          }
        })
        )
    :Container(),
        MessageText != null ?
        Container(child: Text('${MessageText}')):Container()
      ],
    );

  }

  Widget BuildSendBar(BuildContext context){
    return Obx((){
      return Container(
        padding: EdgeInsets.all(10),
        // height:70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width :LoadingNewImageOrVideo.value ? MediaQuery.of(context).size.width *.8 : MediaQuery.of(context).size.width *.6,
              // height: 50,
              child: TextFormField(
                controller: chatMessagesController.MessageFieldController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10 , right: 10),
                  hintText: 'Your message...',
                ),
                onChanged: (value){
                  chatMessagesController.MessageTextContent = value;
                },
              ),
            ),
            LoadingNewImageOrVideo.value ? Container(): GestureDetector(
                onTap: (){
                  LoadImage();
                },
                child: Icon(Icons.image,size: 30,)),
           LoadingNewImageOrVideo.value ? Container() :  GestureDetector(
               onTap: (){
                 LoadVideo();
               },
               child: Icon(Icons.video_collection,size: 30,)),
            GestureDetector(
              onTap: (){
                SendMessage();
              },
                child: Icon(Icons.send , size: 30,),
            ),
          ],
        ),
      );
    });
  }

  Widget BuildCommentMessageBarBeforeSend(BuildContext context , int IndexOfMessage){
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * .6,
            height: chatMessagesController.ChatMessagesList[IndexOfMessage].photo != null || chatMessagesController.ChatMessagesList[IndexOfMessage].video != null ?
            200 : 50,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * .6,
                  height: chatMessagesController.ChatMessagesList[IndexOfMessage].photo != null || chatMessagesController.ChatMessagesList[IndexOfMessage].video != null ?
                  210 : 50,
                  decoration: BoxDecoration(
                    // color: IsMainUser ? Color(0xffc2c8c9) : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chatMessagesController.ChatMessagesList[IndexOfMessage].photo != null?
                      Container(
                          width: MediaQuery.of(context).size.width * .58,
                          height: 150,
                          decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image:GetAndCacheNetworkImageProvider(
                                    chatMessagesController.ChatMessagesList[IndexOfMessage].photo),
                                onError: (err,dd){
                                  print(err);
                                },
                                fit: BoxFit.cover,
                              )
                          )
                      ):Container(),
                      chatMessagesController.ChatMessagesList[IndexOfMessage].video != null ?
                    Container(
                      width: MediaQuery.of(context).size.width * .58,
                      height: 150,
                      color: Colors.black,
                      child: Center(
                        child: Icon(Icons.play_circle_outline,size: 60,),
                      ),
                    ):Container(),
                      chatMessagesController.ChatMessagesList[IndexOfMessage].message != null ?
                      Container(child: Text('${chatMessagesController.ChatMessagesList[IndexOfMessage].message}',maxLines: 1,overflow: TextOverflow.ellipsis),):Container()
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .6,
                  height: chatMessagesController.ChatMessagesList[IndexOfMessage].photo != null || chatMessagesController.ChatMessagesList[IndexOfMessage].video != null ?
                  200 : 50,

                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

              ],
            ),
          ),
        ),
        SizedBox( width: 50,),
        GestureDetector(

            onTap: (){
              chatMessagesController.CommentMessage(1000000000000);
              chatMessagesController.IdOfCommentMessage = -1;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.cancel_outlined,size: 30,color: Colors.red),
            ))

      ],
    );
  }

  Widget BuildSendVideoOrImageBar(BuildContext context){
    BetterVideoPlayerController betterVideoPlayerController = BetterVideoPlayerController();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width * .6,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child:chatMessagesController.LoadingVideo != null ? BuildVideoFileWidget(context,chatMessagesController.LoadingVideo!.path ,betterVideoPlayerController) :(
                chatMessagesController.LoadingImage != null ? Image.file(chatMessagesController.LoadingImage!,fit: BoxFit.cover,):Container()
            ) ,
          ),
        ),
        SizedBox( width: 50,),
        GestureDetector(

            onTap: (){
              LoadingNewImageOrVideo(false);
              chatMessagesController.LoadingVideo = null;
              chatMessagesController.LoadingImage = null;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.cancel_outlined,size: 30,color: Colors.red),
            ))
      ],
    );
  }

 void LoadVideo ()async{
    chatMessagesController.LoadingVideo = await PickVideo();
    if(chatMessagesController.LoadingVideo != null)
      LoadingNewImageOrVideo(true);
 }
 void LoadImage ()async{
    chatMessagesController.LoadingImage = await PickImage();
    if(chatMessagesController.LoadingImage != null)
      LoadingNewImageOrVideo(true);
 }

 void SendMessage()async{
   if(chatMessagesController.MessageFieldController.value.text == '' && LoadingNewImageOrVideo.value == false ){
     return;
    }
   await chatMessagesController.SendNewMessage();
   chatMessagesController.IdOfCommentMessage = -1;
  }

  void ReSendMessage(int index)async{
    await chatMessagesController.ReSendMessage(index);
  }

  void DeleteMessage(int MessageId , int index){
    chatMessagesController.DeleteMessage(MessageId , index);
  }

  void BlockTheChatClicked(BuildContext context , int index) async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await chatMessagesController.BlockTheChat(context , index);

    if (chatMessagesController.State) {
      chatMessagesController.ChatIsBlocked(true);
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          chatMessagesController.Message,
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
          chatMessagesController.Message,
          true);
    }
  }


  void UnBlockTheChatClicked(BuildContext context , int index) async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await chatMessagesController.UnBlockTheChat(context , index);

    if (chatMessagesController.State) {
      chatMessagesController.ChatIsBlocked(false);
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          chatMessagesController.Message,
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
          chatMessagesController.Message,
          true);
    }
  }

  void DeleteTheChatClicked(BuildContext context , int ChatId) async{
    Navigator.of(context).pop();
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await chatMessagesController.DeleteTheChat(context , ChatId);

    if (chatMessagesController.State) {
      Get.off('/all_chat');
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          chatMessagesController.Message,
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
          chatMessagesController.Message,
          true);
    }

  }
}