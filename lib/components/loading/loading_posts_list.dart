import 'package:flutter/material.dart';
import 'loading_list_item.dart';

Widget LoadingPostList(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
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
            children: [
              LoadingListItem.Square(
                width: 40,
                height: 7,
                radius: 20,
                color: Color(0xff076579),
              ),
              SizedBox(
                height: 10,
              ),
              LoadingListItem.Square(
                width: 70,
                height: 7,
                radius: 20,
                color: Color(0xff076579),
              ),
            ],
          )
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: EdgeInsets.only(left: 30,right: 30 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingListItem.Square(
              width: MediaQuery.of(context).size.width * .2,
              height: 7,
              radius: 20,
              color: Color(0xff076579),
            ),
            SizedBox(
              height: 10,
            ),
            LoadingListItem.Square(
              width: MediaQuery.of(context).size.width * .7,
              height: 7,
              radius: 20,
              color: Color(0xff076579),
            ),
            SizedBox(
              height: 10,
            ),
            LoadingListItem.Square(
              width: MediaQuery.of(context).size.width * .4,
              height: 7,
              radius: 20,
              color: Color(0xff076579),
            ),
            SizedBox(
              height: 20,
            ),
            LoadingListItem.Square(
              width: MediaQuery.of(context).size.width * .87,
              height: 100,
              radius: 8,
              color: Color(0xff076579),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    ],
  );
}
