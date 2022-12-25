import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loading/loading_posts_list.dart';
import 'my_divider.dart';

Widget PostList(List<dynamic> postList, BuildContext context , bool isUser ,ScrollController scrollController) {
  return ListView.builder(
    padding: EdgeInsets.only(top: 20),
    itemCount: postList.length+1,
    primary: false,
    controller: scrollController,
    shrinkWrap: true,

    itemBuilder: (context, index) {
      if(index < postList.length){
        var IsOpen = false.obs;
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme == ColorScheme.light()
                    ? Color(0xffececec)
                    : Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                              image: AssetImage('assets/images/sss.jpg'),
                              fit: BoxFit.cover,
                            )),
                        child: null),
                    title: Text(
                      "Facility name",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text("Date"),
                    trailing:  isUser ? null : GestureDetector(
                      onTap: () {
                        print("hi");
                      },
                      child: Icon(Icons.more_vert),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 30),
                      child: Column(
                        children: [
                          MyDivider(context , 1),
                          Obx(() {
                            return GestureDetector(
                              onTap: () {
                                IsOpen(!IsOpen.value);
                              },
                              child: Text(
                                "Semple desssjd kskd fkdfk dfkfkdf kdfkkdf kfkdkfkd kdfkkdf dfkkdkf kdfkdkfkdf  dfkfkdf kdfkkdf kfkdkfkd kdfkkdf dfkkdkf kdfkdkfkdf dfkfkdf kdfkkdf kfkdkfkd kdfkkdf dfkkdkf kdfkdkfkdf dfkfkdf kdfkkdf kfkdkfkd kdfkkdf dfkkdkf kdfkdkfkdfdfkkdkfkd kdfkdfkkdfk dkfkdfkkdf kfkdfkkdfkfkdkfkdfk dkfkdkfkdf dkfkdfkd ",
                                maxLines: IsOpen.value ? 100 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(postList[index]),
                                  fit: BoxFit.cover,
                                )),
                            child: null,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      }
      else{
        return LoadingPostList(context);
      }

    },
  );
}
