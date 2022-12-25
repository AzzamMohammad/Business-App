import 'package:flutter/material.dart';

import 'loading_list_item.dart';

// Widget LoadingImageFromNetwork(double width , double height , String ImageURL){
//   return Container(
//     width: width,
//     height: height,
//     child: FadeInImage(
//       placeholder:ImageProvider<LoadingListItem> (DisplayLoading(width,height)),
//     ),
//   )
// }

Widget DisplayLoading(double width , double height){
  return  LoadingListItem.Square(
    width: width,
    height:  height,
    color: Color(0xff076579), radius:0,
  );
}