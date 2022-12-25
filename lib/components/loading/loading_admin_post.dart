import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading_list_item.dart';

Widget LoadingAdminPost(BuildContext context){
  return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Stack(
        children: [
          LoadingListItem.Square(
            width: MediaQuery
                .of(context)
                .size
                .width * .9,
            height:  MediaQuery
                .of(context)
                .size
                .height * .4,
            radius: 10,
            color: Color(0xff076579),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (BuildContext con, BoxConstraints box) {
                return Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: box.maxWidth,
                  height:  70,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Row(
                    children: [
                      LoadingListItem.Square(
                        width: 50,
                        height: 50,
                        radius: 100,
                        color: Color(0xff076579),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingListItem.Square(
                            width: MediaQuery
                          .of(context)
                          .size
                          .width * .2,
                            height: 7,
                            radius: 20,
                            color: Color(0xff076579),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LoadingListItem.Square(
                            width:MediaQuery
                                .of(context)
                                .size
                                .width * .3,
                            height: 7,
                            radius: 20,
                            color: Color(0xff076579),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },

            )
          )

        ],
      )
  );
}