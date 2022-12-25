import 'package:business_01/modules/forger_password/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';
import 'package:business_01/components/loading/loding_message.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final formKay = GlobalKey<FormState>();
  final  IsHeadOldPassword = true.obs;
  final IsHeadNewPassword = true.obs;
  final IsHeadConfirmPassword = true.obs;
  final TextEditingController pinController = TextEditingController();
  final TextEditingController NewPasswordController = TextEditingController();
  final TextEditingController ConfigPasswordController = TextEditingController();

  final LoadingMessage loadingMessage = LoadingMessage();

  final ForgetPasswordController forgetPasswordController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
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
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .2,
              left: 10,
              right: 10,
            ),
            child: Form(
              key: formKay,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.reset_password}".toUpperCase(),
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(
                    height: 35,
                  ),
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
                      forgetPasswordController.Pin = value!;
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Obx(() {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      obscureText: IsHeadNewPassword.value,
                      controller: NewPasswordController,
                      decoration: InputDecoration(
                        labelText: "${AppLocalizations.of(context)!.new_password}",
                        suffixIcon: IconButton(
                          icon: IsHeadNewPassword.value
                              ? Icon(
                            Icons.visibility_off,
                            size: 20,
                          )
                              : Icon(
                            Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () {
                            IsHeadNewPassword(!IsHeadNewPassword.value);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "${AppLocalizations.of(context)!.enter_your_password}";
                        }else if (value.length < 8) {
                          return "${AppLocalizations.of(context)!.password_most_be_more_tha_8_characters}";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        forgetPasswordController.NewPassword = value!;
                      },
                    );
                  }),
                  SizedBox(
                    height: 17,
                  ),
                  Obx(() {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      obscureText: IsHeadConfirmPassword.value,
                      controller: ConfigPasswordController,
                      decoration: InputDecoration(
                        labelText: "${AppLocalizations.of(context)!.config_password}",
                        suffixIcon: IconButton(
                          icon: IsHeadConfirmPassword.value
                              ? Icon(
                            Icons.visibility_off,
                            size: 20,
                          )
                              : Icon(
                            Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () {
                            IsHeadConfirmPassword(!IsHeadConfirmPassword.value);
                          },
                        ),
                      ),
                      validator: (value) {
                        print("vvvv${value}");
                        print("rrrr${NewPasswordController.value.text}");
                        if (value!.isEmpty) {
                          return "${AppLocalizations.of(context)!.enter_your_password}";
                        }else if (value.length < 8) {
                          return "${AppLocalizations.of(context)!.password_most_be_more_tha_8_characters}";
                        } else if (value != NewPasswordController.value.text) {
                          return "${AppLocalizations.of(context)!.password_and_confirmation_must_be_the_same}";
                        }else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        forgetPasswordController.ConfigNewPassword = value!;                      },
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {

                      final isValid = formKay.currentState?.validate();
                      if (isValid == true) {
                        formKay.currentState?.save();
                        ClickedRestPasswordClicked(context);
                      }
                    },
                    child: Text(
                      "${AppLocalizations.of(context)!.reset_password}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.go_to),
                          GestureDetector(
                            onTap: () {
                              Get.offAllNamed('/login');
                            },
                            child: Text(
                              "${AppLocalizations.of(context)!.login}",
                              style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
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

  void ClickedRestPasswordClicked(BuildContext context)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );

    await forgetPasswordController.ResetPasswordClicked(context);
    if(forgetPasswordController.State){
      loadingMessage.DisplayToast(
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        Colors.white,
        forgetPasswordController.Message,
        true,);
      forgetPasswordController.sharedData.DeleteTemporaryEmail();
      Get.offAllNamed('/home_page');
    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          forgetPasswordController.Message,
          false);
    }

  }
}
