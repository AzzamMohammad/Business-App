import 'package:flutter/cupertino.dart';

import 'loading_list_item.dart';

Widget LoadingFollowingImage(BuildContext context){
  return Padding(
    padding: EdgeInsets.only(left: 5, right: 5),
    child: Container(
      child: Column(
        children: [
          LoadingListItem.Square(
            width: 85,
            height: 85,
            radius: 170,
            color: Color(0xff076579),
          ),
          SizedBox(height: 10,),
          LoadingListItem.Square(
            width: 70,
            height: 10,
            radius: 10,
            color: Color(0xff076579),
          ),
        ],
      ),
    )
  );
}