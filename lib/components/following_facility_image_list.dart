import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'loading/loading_following_image.dart';

Widget FollowingFacilityImageList(List<dynamic> postList,
    BuildContext context) {
  return SizedBox(
    height: 150,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(top: 15),
      itemCount: postList.length + 1,
      itemBuilder: (context, index) {
        if (index < postList.length) {
        return Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: 85,
            // height: 40,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 85,
                  width:85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(140)),
                    image: DecorationImage(
                      image: AssetImage(postList[index]),
                      fit: BoxFit.cover,
                      // opacity: Theme.of(context).colorScheme == ColorScheme.light() ? 50 : 120
                    ),
                  ),
                ),
                AutoSizeText("Facility name kkkk" ,minFontSize: 15, maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontSize: 15),),
              ],
            ),
          )
        );
        } else {
          return LoadingFollowingImage(context);
        }
      },
    ),
  );
}
