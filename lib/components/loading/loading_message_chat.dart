import 'package:flutter/material.dart';
import 'loading_list_item.dart';

Widget LoadingMessageChat(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top :10 , left: 10,right: 10),
    child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LoadingListItem.Square(
              width: MediaQuery.of(context).size.width * .3,
              height: 40,
              radius: 10,
              color: Color(0xffc2c8c9),
            ),

          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LoadingListItem.Square(
              width: MediaQuery.of(context).size.width * .6,
              height: 40,
              radius: 10,
              color: Colors.blueAccent,
            ),

          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LoadingListItem.Square(
              width: MediaQuery.of(context).size.width * .5,
              height: 40,
              radius: 10,
              color: Color(0xffc2c8c9),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    ),
  );
}