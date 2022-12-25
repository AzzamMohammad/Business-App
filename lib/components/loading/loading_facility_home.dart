import 'package:business_01/components/my_divider.dart';
import 'package:flutter/cupertino.dart';

import 'loading_list_item.dart';

Widget LoadingFacilityHome(BuildContext context){
  return Padding(
      padding: EdgeInsets.only(left: 8, right: 8,top: 40),
      child: ListView(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width,
                  height:  MediaQuery.of(context).size.height * .35,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                SizedBox(height: 30,),
                LoadingListItem.Square(
                  width: 120,
                  height: 15,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                SizedBox(height: 10,),
                LoadingListItem.Square(
                  width: 200,
                  height: 15,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                SizedBox(height: 10,),
                LoadingListItem.Square(
                  width: 90,
                  height: 15,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                SizedBox(height: 20,),
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingListItem.Square(
                      width: 150,
                      height: 50,
                      radius: 10,
                      color: Color(0xff076579),
                    ),

                  ],

                ),
                SizedBox(height: 20,),
                LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width,
                  height: 15,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                SizedBox(height: 10,),
                LoadingListItem.Square(
                  width: 180,
                  height: 15,
                  radius: 10,
                  color: Color(0xff076579),
                ),
                SizedBox(height: 20,),
                // LoadingListItem.Square(
                //   width: MediaQuery.of(context).size.width,
                //   height: 2,
                //   radius: 10,
                //   color: Color(0xff076579),
                // ),
                // SizedBox(height: 20,),
              ],
            ),
          ),
        ]
      )
  );
}