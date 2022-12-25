import 'package:business_01/components/loading/loding_message.dart';
import 'package:business_01/modules/check_PIN/check_PIN_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';

class CheckPINScreen extends StatelessWidget {
  final CheckPINController checkPINController = Get.find();

  LoadingMessage loadingMessage = LoadingMessage();

  final formKay = GlobalKey<FormState>();
  final TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
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
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .27, left: 10),
              child: Text(
                "${AppLocalizations.of(context)!.confirm_account}".toUpperCase(),
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
              child: ListView(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    controller: pinController,
                    decoration: InputDecoration(
                      labelText: "${AppLocalizations.of(context)!.pin}",
                    ),
                    validator: (value1) {
                      if (value1!.isEmpty) {
                        return '${AppLocalizations.of(context)!.enter_the_pin}';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      checkPINController.PIN = value!;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final isValid = formKay.currentState?.validate();
                      if(isValid == true){
                        formKay.currentState?.save();
                        ClickSend(context);
                      }
                    },
                    child: Text('${AppLocalizations.of(context)!.send}',style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ClickResendPIN(context);
                          },
                          child: Text(
                            "${AppLocalizations.of(context)!.resend_pin}",
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
          ),
        ],
      ),
    );
  }

  void ClickSend(BuildContext context)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await checkPINController.SendClicked(context);
    if(checkPINController.stateNext == true){
      checkPINController.sharedData.DeleteTemporaryEmail();
      checkPINController.sharedData.DeleteTemporaryPassword();
      loadingMessage.Dismiss();
      Get.offAllNamed('/home_page');
    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          checkPINController.messageNext,
          false);
    }
  }

  void ClickResendPIN(BuildContext context)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await checkPINController.ResendClicked(context);
    if(checkPINController.stateResend){
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          checkPINController.messageResend,
          false);
    }
    else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          checkPINController.messageResend,
          false);
    }
  }
}
