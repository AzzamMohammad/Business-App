import 'package:business_01/modules/all_facility-for_owner_drawer/all_facility_for_owner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/cach_image_from_network.dart';
import '../../components/loading/loading_members.dart';

AllFacilityForOwnerController allFacilityForOwnerController = AllFacilityForOwnerController();

Widget BuildAllFacilityForOwner(BuildContext context){
  return ClipRRect(
    borderRadius:rtlLanguages.contains(Get.locale?.languageCode)? BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)):BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
    child: Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'My facilities',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme == ColorScheme.light()
                                ? Color(0xff076579)
                                : Color(0xffefefef),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                 BuildAddFacility(context),
                ],
              ),
              Divider(
                  thickness: 2,
                  color: Theme.of(context).colorScheme == ColorScheme.light()
                      ? Color(0xff076579)
                      : Color(0xffefefef)),
              Obx((){
                if(allFacilityForOwnerController.IsLoaded.value){
                  if(allFacilityForOwnerController.NumberOfFacilitiesInList.value == 0)
                    return Column(
                      children: [
                        Center(
                          child: Text('Start your business'),
                        ),
                        BuildAddFacility(context),
                      ],
                    );
                  return Expanded(
                    child: ListView.builder(
                      controller: allFacilityForOwnerController.FacilityOwnerController,
                        itemCount: allFacilityForOwnerController.NumberOfFacilitiesInList.value + 1,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder:(context,index){
                          if(index < allFacilityForOwnerController.NumberOfFacilitiesInList.value)
                            return BuildFacilityCard(context,index);
                          else{
                            if(!allFacilityForOwnerController.ArrivedToEndOfList)
                              return Padding(
                                padding: EdgeInsets.only(top: 4,bottom: 4),
                                child: LoadingMemberOfList(context),
                              );
                            return Container();
                          }

                        }
                    ),
                  );
                }else{
                  allFacilityForOwnerController.GetNewFacilitiesForOwner();
                  return Padding(
                    padding: EdgeInsets.only(top: 4,bottom: 4),
                    child: LoadingMemberOfList(context),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget BuildFacilityCard(BuildContext context , int Index){
  return GestureDetector(
    onTap: (){
      Get.toNamed('/facility',arguments: {'facility_id':allFacilityForOwnerController.FacilitiesList[Index].id,'is_user':false});
    },
    child: Container(
      child: Padding(
        padding:  EdgeInsets.only(top: 4,bottom: 4),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                image:
                DecorationImage(
                  image:GetAndCacheNetworkImageProvider(
                      allFacilityForOwnerController.FacilitiesList[Index].photo),
                  onError: (err,dd){
                    print(err);
                  },
                  fit: BoxFit.cover,
                )),
          ),
          title: Text(
            '${allFacilityForOwnerController.FacilitiesList[Index].name}',
            style: TextStyle(fontSize: 14, color: Color(0xff076579),),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
  );
}

Widget BuildAddFacility (BuildContext context){
  return  GestureDetector(
    onTap: (){},
    child: Container(
      width: 50,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xff076579)
      ),
      child: Center(
        child: Text('New',style: TextStyle(color: Color(0xffefefef),),),
      ),
    ),
  );
}