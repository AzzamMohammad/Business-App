import 'package:business_01/components/my_divider.dart';
import 'package:flutter/cupertino.dart';

import 'loading_list_item.dart';

Widget LoadingFacilityImage(BuildContext context){
  return Padding(
      padding: EdgeInsets.only(left: 8, right: 8,top: 40),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .3,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .3,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .3,
                  radius: 10,
                  color: Color(0xff076579),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .3,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .3,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .3,
                  radius: 10,
                  color: Color(0xff076579),
                ),
              ],
            )
          ],
        ),
      )
  );
}