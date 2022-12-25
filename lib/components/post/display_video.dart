import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

Widget DisplayVideo(
    VideoPlayerController videoPlayerController, BuildContext context) {
  var Refrech = false.obs;

  videoPlayerController
    ..addListener(() {
      Refrech(!Refrech.value);
    })
  ..setLooping(true)
  ..initialize().then((_)=>videoPlayerController.play());


  Obx((){
    if (Refrech.value != !Refrech.value) {
      if (videoPlayerController.value.isInitialized) {
        return Container(
          alignment: Alignment.topCenter,
          child: VideoPlayer(videoPlayerController),
        );
      } else {
        return Container(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    }
    else
      return Container();
  });
  return Container();
}
