import 'package:better_video_player/better_video_player.dart';
import 'package:flutter/material.dart';

Widget BuildVideoNetworkWidget(BuildContext context,String VideoUrl , BetterVideoPlayerController? betterVideoPlayerController){
  BetterVideoPlayerController bb;
  if(betterVideoPlayerController == null){
     bb = BetterVideoPlayerController();
    bb.dispose();
  }else{
    bb= betterVideoPlayerController;
  }

  return  Container(
    width: MediaQuery.of(context).size.width * .58,
    height: 150,
    child: BetterVideoPlayer(
      controller: bb,
      dataSource: BetterVideoPlayerDataSource(
          BetterVideoPlayerDataSourceType.network,
          VideoUrl),
      configuration: BetterVideoPlayerConfiguration(
        autoPlay: true,
        allowedScreenSleep: false,
      ),
    ),
  );
}

Widget BuildVideoFileWidget(BuildContext context,String VideoUrl , BetterVideoPlayerController betterVideoPlayerController){
  return  Container(
    width: MediaQuery.of(context).size.width * .58,
    height: 150,
    child: BetterVideoPlayer(
      controller: betterVideoPlayerController,
      dataSource: BetterVideoPlayerDataSource(
          BetterVideoPlayerDataSourceType.network,VideoUrl
          ),
      configuration: BetterVideoPlayerConfiguration(
        // autoPlay: true,
        // allowedScreenSleep: false,
        // placeholder: Text('looood'),
        // autoPlayWhenResume: true,

      ),
    ),
  );
}