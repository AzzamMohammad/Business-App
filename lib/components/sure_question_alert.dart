import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

void SureQuestionAlert (void Function()? Tap , BuildContext context){
   Alert(
     context: context,
     title: "${AppLocalizations.of(context)!.are_you_sure}",
     buttons: [
       DialogButton(
         width: MediaQuery.of(context).size.width * .8,
         height: 50,
         child:  Text(
           "${AppLocalizations.of(context)!.go_back}",
           style: TextStyle(
               color: Colors.white, fontWeight: FontWeight.bold),
         ),
         onPressed: (){
           Navigator.of(context).pop();
         },
         padding: EdgeInsets.all(8),
         color: Color(0xff076579),
       ),
       DialogButton(
         width: MediaQuery.of(context).size.width * .8,
         height: 50,
         child:  Text(
           "${AppLocalizations.of(context)!.yes}",
           style: TextStyle(
               color: Colors.white, fontWeight: FontWeight.bold),
         ),
         onPressed: Tap,
         padding: EdgeInsets.all(8),
         color: Color(0xff076579),
       ),

     ],
       style: AlertStyle(
         backgroundColor: Theme.of(context).colorScheme == ColorScheme.light()
             ? Color(0xffececec)
             : Color(0xff181818),
         animationType: AnimationType.grow,
         isCloseButton: false,
         isButtonVisible: true,
         isOverlayTapDismiss: false,
         animationDuration: Duration(milliseconds: 600),
         alertBorder: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(8),
           side: BorderSide(
             color: Theme.of(context).colorScheme == ColorScheme.light()
                 ? Color(0xff076579)
                 : Colors.white,
             // width: MediaQuery.of(context).size.width
           ),
         ),
         // alertPadding:
         // EdgeInsets.only(top: MediaQuery.of(context).size.height * .11),
         constraints:
         BoxConstraints.expand(width: MediaQuery.of(context).size.width),
         overlayColor: Colors.black54,
         alertElevation: 200,
         alertAlignment: Alignment.center,
         buttonsDirection: ButtonsDirection.row,
       )
   ).show();
}