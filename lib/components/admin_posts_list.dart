import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'loading/loading_admin_post.dart';


Widget AdminPostsList(List<dynamic> postList,
    BuildContext context) {
  return SizedBox(
    height: MediaQuery
        .of(context)
        .size
        .height * .25,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(top: 10),
      itemCount: postList.length + 1,
      itemBuilder: (context, index) {
        if (index < postList.length) {
          return Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Container(
              // height: 70,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage(postList[index]),
                    fit: BoxFit.cover,
                    opacity: Theme.of(context).colorScheme == ColorScheme.light() ? 50 : 120
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 3),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AutoSizeText("Facility name Facility name Facility name", maxLines: 2,
                    maxFontSize: 25,
                    minFontSize: 18,
                    style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                ),
              ),
            ),
          );
        } else {
          return LoadingAdminPost(context);
        }
      },
    ),
  );
}
