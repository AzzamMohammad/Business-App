import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cach_image_from_network.dart';
import '../my_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

Widget PostListTile(
    BuildContext context,
    bool isUser,
    String FacilityImage,
    String FacilityName,
    DateTime PostDate,
    String Title,
    String description,
    String PostImage,
        List<PopupMenuEntry<Widget>> Function(BuildContext) SitingListItems,
    int FacilityId
    ) {
  var IsOpen = false.obs;
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme == ColorScheme.light()
              ? Color(0xffececec)
              : Color(0xff111111),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            ListTile(
                leading: GestureDetector(
                  onTap: (){
                    if(isUser)
                    Get.toNamed('/facility', arguments: {
                      'facility_id': FacilityId,
                      'is_user': true
                    });
                  },
                  child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image: GetAndCacheNetworkImageProvider(
                                FacilityImage),
                            onError: (err,dd){
                              print(err);
                            },

                            fit: BoxFit.cover,
                          )),
                      child: null),
                ),
                title: GestureDetector(
                  onTap: (){
                    if(isUser)
                      Get.toNamed('/facility', arguments: {
                        'facility_id': FacilityId,
                        'is_user': true
                      });
                  },
                  child: Text(
                    "${FacilityName}",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                subtitle: Text(
                  "${DateOfAdding(PostDate, context)}",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: isUser
                    ? null
                    : PopupMenuButton<Widget>(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .4,
                            minWidth: MediaQuery.of(context).size.width * .4,),
                        color: Theme.of(context).colorScheme == ColorScheme.light() ? Color(0xffefefef) :
                        Color(0xff1a1a1a),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        itemBuilder:SitingListItems
                      ),),
            Padding(
                padding: EdgeInsets.only(right: 20, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyDivider(context, 1),
                    Text(
                      "${Title}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color(0xff076579)),
                    ),
                    Obx(() {
                      return GestureDetector(
                        onTap: () {
                          IsOpen(!IsOpen.value);
                        },
                        child: Text(
                          "${description}",
                          maxLines: IsOpen.value ? 100 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    PostImage != ""
                        ? Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                  image:GetAndCacheNetworkImageProvider(PostImage
                                  ),
                                  onError: (err,dd){
                                    print(err);
                                  },
                                  fit: BoxFit.fill,
                                )),
                            child: null,
                          )
                        : Container(),

                    // TODO : Add vedio
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

String DateOfAdding(DateTime date, BuildContext context) {
  DateTime naw = DateTime.now();
  var Difference = naw.difference(date);
  if (Difference.inHours < 1) {
    return '${Difference.inMinutes} ${AppLocalizations.of(context)!.minute}';
  } else if (Difference.inHours < 24) {
    return '${Difference.inHours} ${AppLocalizations.of(context)!.hour}';
  } else if (Difference.inDays < 7) {
    return '${Difference.inDays} ${AppLocalizations.of(context)!.day}';
  } else if (Difference.inDays > 7 && Difference.inDays < 30) {
    int week = Difference.inDays ~/ 7;
    if (week < 4)
      return '${week} ${AppLocalizations.of(context)!.week}';
    else
      return '${AppLocalizations.of(context)!.month}';
  } else if (Difference.inDays < 360) {
    int month = Difference.inDays ~/ 30;
    if (month < 1) month = 1;
    if (month > 12) month = 12;
    return '${month} ${AppLocalizations.of(context)!.month}';
  } else {
    return "${Difference.inDays}";
  }
}
