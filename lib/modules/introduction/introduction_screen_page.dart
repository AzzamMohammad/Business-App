import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class IntroductionScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
                title: "${AppLocalizations.of(context)!.business}",
                body: "${AppLocalizations.of(context)!.get_all_the_services}",
                image: Image.asset('assets/images/businessman.png'),
                decoration: PageDecoration(
                    titleTextStyle: TextStyle(fontSize: 30, color: Colors.blue),
                    bodyTextStyle: TextStyle(fontSize: 20, color: Colors.blue),
                    imagePadding: EdgeInsets.all(8),
                    bodyPadding: EdgeInsets.only(top: 20))),
            PageViewModel(
              title: "${AppLocalizations.of(context)!.business}",
              body:
                  "${AppLocalizations.of(context)!.hurry_up_to_expand_your_business}",
              image: Image.asset('assets/images/lineman.png'),
              decoration: PageDecoration(
                  titleTextStyle: TextStyle(fontSize: 30, color: Colors.blue),
                  bodyTextStyle: TextStyle(fontSize: 20, color: Colors.blue),
                  imagePadding: EdgeInsets.all(8),
                  bodyPadding: EdgeInsets.only(top: 20)),
            ),
            PageViewModel(
              title: "${AppLocalizations.of(context)!.business}",
              body:
                  "${AppLocalizations.of(context)!.ease_of_communication_between_the_client_and_the_customer}",
              image: Image.asset('assets/images/job.png'),
              decoration: PageDecoration(
                  titleTextStyle: TextStyle(fontSize: 30, color: Colors.blue),
                  bodyTextStyle: TextStyle(fontSize: 20, color: Colors.blue),
                  imagePadding: EdgeInsets.all(8),
                  bodyPadding: EdgeInsets.only(top: 20)),
            ),
          ],
          showSkipButton: true,
          skip: Text("${AppLocalizations.of(context)!.skip}",style:TextStyle(fontSize: 17,color: Colors.blue),),
          showNextButton: true,
          next: Icon(Icons.arrow_forward,size: 30,color: Colors.blue,),
          dotsDecorator: DotsDecorator(
              color: Colors.grey,
              activeSize: Size(22, 10),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              activeColor: Colors.blue),
          done: Text(
            "${AppLocalizations.of(context)!.create_account}",style:TextStyle(fontSize: 15,color: Colors.blue), maxLines: 1,
          ),
          onDone: () {
            Get.offAllNamed('/register');
          },
        ),
      ),
    );
  }
}
