import 'package:business_01/modules/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class SplashScreen extends StatelessWidget {

  final SplashController splashController = Get.find();
  @override
  Widget build(BuildContext context) {
    splashController.buildContext = context;
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/busenessLogo.png',
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.height * .7,
                // fit: BoxFit.fitWidth,

              ),
              LoadingAnimationWidget.staggeredDotsWave(
                color:  Theme.of(context).primaryColor,
                size: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
