import 'package:flutter/material.dart';
import 'loading_list_item.dart';

Widget LoadingMemberOfList(BuildContext context) {
  return Column(
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
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
                  width: MediaQuery.of(context).size.width * .1,
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
              ],
            )
          ],
        ),
      ),

    ],
  );
}
