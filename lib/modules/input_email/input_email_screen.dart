import 'package:business_01/components/loading/loding_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';
import 'input_email_controller.dart';

class InputEmailScreen extends StatelessWidget {
  final formKay = GlobalKey<FormState>();
  InputEmailController inputEmailController = Get.find();
  LoadingMessage loadingMessage = LoadingMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/images/top1.png",
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .25,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/images/top2.png",
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .25,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .23,left: 10),
              child: Text(
                "${AppLocalizations.of(context)!.reset_password}".toUpperCase(),
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .4,
              left: 10,
              right: 10,
            ),
            child: Form(
              key: formKay,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "${AppLocalizations.of(context)!.email}",
                    ),
                    validator: (value) {
                      final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);

                      if (value!.isEmpty) {
                        return '${AppLocalizations.of(context)!.enter_your_email}';
                      } else if (!regExp.hasMatch(value)) {
                        return '${AppLocalizations.of(context)!.enter_a_valid_email}';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      inputEmailController.Email = value!;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final isValid = formKay.currentState?.validate();
                      if (isValid == true) {
                        formKay.currentState?.save();
                        OnSendPinClicked(context);
                      }
                    },
                    child: Text(
                      "${AppLocalizations.of(context)!.send_pin}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context)!.go_to),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/register');
                                },
                                child: Text(
                                  "${AppLocalizations.of(context)!.sign_in}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  void OnSendPinClicked(BuildContext context)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );

    await inputEmailController.SendPinClicked(context);
    if(inputEmailController.State){
      loadingMessage.DisplayToast(
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        Colors.white,
        AppLocalizations.of(context)!
            .you_must_confirm_your_account_the_code_has_been_sent_to_your_email,
        true,);
      inputEmailController.sharedData.SaveTemporaryEmail(inputEmailController.Email);
      Get.toNamed('/forget_password');
    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          inputEmailController.Message,
          false);
    }
  }
}
