import 'package:business_01/components/loading/loding_message.dart';
import 'package:business_01/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.find();
  final formKay = GlobalKey<FormState>();
  final IsHead = true.obs;
  final IsSave = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoadingMessage loadingMessage = LoadingMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
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
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .17, left: 10),
              child: Text(
                "${AppLocalizations.of(context)!.login}".toUpperCase(),
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .3,
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
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "${AppLocalizations.of(context)!.email}",
                    ),
                    validator: (value) {
                      final pattern =
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
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
                      loginController.userEmail = value!;
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Obx(() {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      controller: passwordController,
                      obscureText: IsHead.value,
                      decoration: InputDecoration(
                        labelText: "${AppLocalizations.of(context)!.password}",
                        suffixIcon: IconButton(
                          icon: IsHead.value
                              ? Icon(
                                  Icons.visibility_off,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.visibility,
                                  size: 20,
                                ),
                          onPressed: () {
                            IsHead(!IsHead.value);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "${AppLocalizations.of(context)!.enter_your_password}";
                        } else if (value.length < 8) {
                          return "${AppLocalizations.of(context)!.password_most_be_more_tha_8_characters}";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        loginController.userPassword = value!;
                      },
                    );
                  }),
                  SizedBox(
                    height: 17,
                  ),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.remember_me}",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            IsSave(!IsSave.value);
                            // loginController.sharedData.SaveEmail(loginController.userEmail);
                            // loginController.sharedData.SavePassword(loginController.userPassword);
                          },
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3),
                                color: IsSave.value == false
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Theme.of(context).primaryColor),
                            child: Icon(
                              Icons.check,
                              color: IsSave.value == false
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Colors.white,
                              size: 17,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final isValid = formKay.currentState?.validate();
                      if (isValid == true) {
                        formKay.currentState?.save();
                        loginController.sharedData
                            .SaveTemporaryEmail(loginController.userEmail);
                        if (IsSave.value) {
                          loginController.sharedData
                              .SaveEmail(loginController.userEmail);
                          loginController.sharedData
                              .SavePassword(loginController.userPassword);
                        }
                        OnClickLogin(context);
                      }
                    },
                    child: Text(
                      "${AppLocalizations.of(context)!.login}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadingMessage.DisplayToast(
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor,
                              Colors.white,
                              AppLocalizations.of(context)!
                                  .enter_your_email_to_send_the_verification_code,
                              true,);
                            Get.toNamed('/input_email');
                          },
                          child: Text(
                            "${AppLocalizations.of(context)!.forget_Password}",
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context)!.go_to),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/register');
                                },
                                child: Text(
                                  "${AppLocalizations.of(context)!.register}",
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

  void OnClickLogin(BuildContext context) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );

    await loginController.LoginClicked(context);

    if (loginController.state) {
      loadingMessage.Dismiss();
      Get.offAllNamed('/home_page');
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          loginController.message,
          true);
      if (loginController.isConfirm == false) {
        loginController.sharedData.SaveTemporaryEmail(loginController.userEmail);
        loginController.sharedData.SaveTemporaryPassword(loginController.userPassword);
        loadingMessage.DisplayToast(
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          Colors.white,
          AppLocalizations.of(context)!
              .you_must_confirm_your_account_the_code_has_been_sent_to_your_email,
          true,);
        Get.toNamed('/check_pin');
      }
    }
  }
}
