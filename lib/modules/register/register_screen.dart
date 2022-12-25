import 'package:business_01/components/loading/loding_message.dart';
import 'package:business_01/constants.dart';
import 'package:business_01/models/location.dart';
import 'package:business_01/modules/register/register_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';



class RegisterScreen extends StatelessWidget {
  RegisterController registerController = Get.find();

  final formKay = GlobalKey<FormState>();
  final formKay2 = GlobalKey<FormState>();
  final GoToFirstPage = true.obs;
  final GoToSecondPage = false.obs;
  final GoToLAstPage = false.obs;
  final IsHead = true.obs;
  final IsSave = false.obs;
  final selectedCountry = ''.obs;
  final selectedCity = ''.obs;
  final selectedTown = ''.obs;
  final selectedGender = ''.obs;
  final selectedCodePhone = ''.obs;
  final selectedBirthDate = DateTime(1907).obs;
  var CityFieldIsAvilable = true.obs;
  var TownFieldIsAvilable = true.obs;
  String? SelectedCityHelper ;
  String? SelectedCountryHelper;
  String? SelectedTownHelper;
  String? SelectedGenderHelper ;
  String? SelectedCodePhoneHelper;
  var ReFreshCity = false.obs;
  var ReFreshCountry = false.obs;
  var ReFreshTown = false.obs;
  var ReFreshGender = false.obs;
  var ReFreshCodePhone = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNamedController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController telephoneNumberController = TextEditingController();
  final LoadingMessage loadingMessage = LoadingMessage();

  // List<String> countryList = List.from(CountryList);
  // List<String> cityList = List.from(CityList);
  // List<String> townList = List.from(TownList);



  List<String> countryCodePhoneList = [
    '+963',
    '+951',
    '+748',
  ];




  int Count = 0;

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items, var selectedValue) {
    List<DropdownMenuItem<String>> _menuItems = [];
    // int Count = 0;
    for (var item in items) {
      // if (Count == 0) {
      //   selectedValue(item);
      //   Count++;
      // }
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights(List<String> items) {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(5);
      }
    }
    return _itemsHeights;
  }

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
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .17,left: 10),
              child: Text(
                "${AppLocalizations.of(context)!.register}".toUpperCase(),
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
            child: Obx(
                (){
                  if(GoToFirstPage.value){
                    return BuildFirstWidget(context);
                  }
                  else if (GoToSecondPage.value)
                    return BuildSecondWidget(context);
                  else
                    return BuildLastWidget(context);
                }
            )
          ),
        ],
      ),
    );
  }
   void OnClickRegister(BuildContext context)async{
    loadingMessage.DisplayLoading(
       Theme.of(context).scaffoldBackgroundColor,
       Theme.of(context).primaryColor,
     );
    await registerController.RegisterClicked(context);

    if(registerController.status == true){
      registerController.sharedData.SaveTemporaryEmail(registerController.email);
      registerController.sharedData.SaveTemporaryPassword(registerController.password);
      loadingMessage.DisplayToast(
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        Colors.white,
        AppLocalizations.of(context)!
            .you_must_confirm_your_account_the_code_has_been_sent_to_your_email,
        true,);
      Get.toNamed('/check_pin');
    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          registerController.message,
          false,
      );
    }
  }


  Widget BuildFirstWidget(BuildContext context){
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: formKay,
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
              registerController.email = value!;
              print(registerController.email);
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
                }else if(value.length < 8){
                  return "${AppLocalizations.of(context)!.password_most_be_more_tha_8_characters}";
                }
                else {
                  return null;
                }
              },
              onSaved: (value) {
                registerController.password = value!;
              },
            );
          }),
          SizedBox(
            height: 17,
          ),
          TextFormField(
            keyboardType: TextInputType.name,
            maxLines: 1,
            controller: firstNamedController,
            decoration: InputDecoration(
              labelText: "${AppLocalizations.of(context)!.first_name}",
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "${AppLocalizations.of(context)!.enter_your_first_name}";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              registerController.firstName = value!;
            },
          ),
          SizedBox(
            height: 17,
          ),
          TextFormField(
            keyboardType: TextInputType.name,
            maxLines: 1,
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: "${AppLocalizations.of(context)!.last_name}",
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return '${AppLocalizations.of(context)!.enter_your_last_name}';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              registerController.lastName = value!;
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .9, 50)),
                  maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .9, 50)),
                ),
                onPressed: () {

                  final isValid = formKay.currentState?.validate();
                  if ( isValid ==true) {
                    formKay.currentState?.save();
                    if(IsSave.value){

                    }
                    GoToFirstPage(false);
                    GoToSecondPage(true);
                  }

                },
                child: Text(
                  "${AppLocalizations.of(context)!.next}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.go_to),
                GestureDetector(
                  onTap: () {
                    // print(registerController.country);
                    Get.toNamed('/login');
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
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget BuildSecondWidget(BuildContext context){
    return ListView(
      children: [

        DropdownButtonHideUnderline(
          child: Obx(
                () {
              return DropdownButton2(
                  isExpanded: ReFreshCountry.value,
                  // عناصر اللست وهم محتويات القائمة
                  items: _addDividersAfterItems(
                      CountryList.map((country) => country.name).toList(), selectedCountry),
                  hint: Text(
                    "${AppLocalizations.of(context)!.select_country}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor),
                  ),
                  customItemsHeights:
                  _getCustomItemsHeights(CountryList.map((country) => country.name).toList()),
                  // حجم الإطار حول العنصر في القائمة
                  // customItemsHeights: 10,
                  // القيمة التي يأخذها الحقل الأساسي لقائمة وهو قيمة الخيار
                  value: SelectedCountryHelper,
                  onChanged: (value) {
                    ReFreshCountry(!ReFreshCountry.value);
                    selectedCountry(value.toString());
                    registerController.CountryIndex(CountryList.lastIndexWhere((country) =>country.name == selectedCountry.value));
                    registerController.CityIndex(0);
                    registerController.TownIndex(0);
                    if(CountryList[registerController.CountryIndex.value].city.isEmpty){
                      TownFieldIsAvilable(false);
                      CityFieldIsAvilable(false);
                    }else if(CountryList[registerController.CountryIndex.value].city[0].region.isEmpty){
                      TownFieldIsAvilable(false);
                    }else{
                      TownFieldIsAvilable(true);
                      CityFieldIsAvilable(true);
                    }
                    SelectedCityHelper = null;
                    selectedCity('');
                    SelectedTownHelper = null;
                    selectedTown('');
                    SelectedCountryHelper = selectedCountry.value;
                  },

                  // زر القائمة عندما تكون مغلقة
                  icon: Icon(
                    Icons.arrow_drop_down,
                  ),

                  // زر القائمة عندما تكون مفتوحة
                  iconOnClick: Icon(
                    Icons.arrow_drop_up,
                  ),
                  iconSize: 30,

                  // تنسيق الحقل
                  buttonHeight: 60,
                  iconDisabledColor: Theme.of(context).primaryColor,
                  iconEnabledColor: Theme.of(context).primaryColor,
                  buttonPadding:
                  const EdgeInsets.only(left: 10, right: 10),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  buttonElevation: 4,

                  //تنسيق العنصر داخل القائمة
                  itemHeight: 40,
                  // itemPadding: const EdgeInsets.only(left: 7, right: 7),
                  selectedItemHighlightColor: Color(0xff189AB4),

                  // تنسيق القائمة
                  // dropdownWidth: MediaQuery.of(context).size.width * .95,
                  dropdownPadding:
                  const EdgeInsets.only(left: 10, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  dropdownElevation: 8,
                  enableFeedback: true,
                  scrollbarRadius: const Radius.circular(40),
                  // مكان القائمة عندما تفتح بالنسبة للزر
                  offset: Offset(0, 5),
                  scrollbarAlwaysShow: true,
                  scrollbarThickness: 10,
                  dropdownMaxHeight: 200,
                  searchController: registerController.textEditingCountryController,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      controller: registerController.textEditingCountryController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: '${AppLocalizations.of(context)!.write_to_search}',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value
                        .toString()
                        .contains(searchValue));
                  },
                  //This to clear the search value when you close the menu
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      registerController.textEditingCountryController
                          .clear();
                    }
                  }
              );
            },
          ),
        ),
        SizedBox(
          height: 17,
        ),
        CityFieldIsAvilable.value==true ? DropdownButtonHideUnderline(
          child: Obx(

                () {
                  List<String> CityList = CountryList[registerController.CountryIndex.value].city.map((city) => city.name).toList();
                  return CityList.length != 0 ? DropdownButton2(
                isExpanded: ReFreshCity.value,
                // عناصر اللست وهم محتويات القائمة
                items: _addDividersAfterItems(CityList, selectedCity),

                hint: Text(
                   "${AppLocalizations.of(context)!.select_city}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor),
                ),
                customItemsHeights: _getCustomItemsHeights(CityList),
                // حجم الإطار حول العنصر في القائمة
                // customItemsHeights: 10,
                // القيمة التي يأخذها الحقل الأساسي لقائمة وهو قيمة الخيار
                value:SelectedCityHelper,
                onChanged: (value) {
                  ReFreshCity(!ReFreshCity.value);
                  selectedCity(value.toString());
                  registerController.CityIndex(CountryList[registerController.CountryIndex.value].city.lastIndexWhere((city) =>city.name ==  selectedCity.value));
                  selectedTown('');
                  if(CountryList[registerController.CountryIndex.value].city[registerController.CityIndex.value].region.isEmpty){
                    TownFieldIsAvilable (false);
                  }else{
                    TownFieldIsAvilable (true);
                  }
                  registerController.TownIndex(0);
                  SelectedTownHelper = null;
                  SelectedCityHelper = selectedCity.value;
                },

                // زر القائمة عندما تكون مغلقة
                icon: Icon(
                  Icons.arrow_drop_down,
                ),

                // زر القائمة عندما تكون مفتوحة
                iconOnClick: Icon(
                  Icons.arrow_drop_up,
                ),
                iconSize: 30,

                // تنسيق الحقل
                buttonHeight: 60,
                iconDisabledColor: Theme.of(context).primaryColor,
                iconEnabledColor: Theme.of(context).primaryColor,
                buttonPadding:
                const EdgeInsets.only(left: 10, right: 10),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                buttonElevation: 4,

                //تنسيق العنصر داخل القائمة
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 7, right: 7),
                selectedItemHighlightColor: Color(0xff189AB4),

                // تنسيق القائمة
                // dropdownWidth: MediaQuery.of(context).size.width * .95,
                dropdownPadding:
                const EdgeInsets.only(left: 10, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                dropdownElevation: 8,
                enableFeedback: true,
                scrollbarRadius: const Radius.circular(40),
                // مكان القائمة عندما تفتح بالنسبة للزر
                offset: Offset(0, 5),
                scrollbarAlwaysShow: true,
                scrollbarThickness: 10,
                dropdownMaxHeight: 200,
                searchController: registerController.textEditingCityController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    controller: registerController.textEditingCityController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: '${AppLocalizations.of(context)!.write_to_search}',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value
                      .toString()
                      .contains(searchValue));
                },
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    registerController.textEditingCityController.clear();
                  }
                },
              ):Container(width: 0,height: 0,);
            },
          ),
        ):Container(),
        SizedBox(
          height: 17,
        ),
        TownFieldIsAvilable.value==true ? DropdownButtonHideUnderline(
          child: Obx(
                () {
                  List<String> TownList = CountryList[registerController.CountryIndex.value].city[registerController.CityIndex.value].region.map((town) => town.name).toList();
              return TownList.length !=0? DropdownButton2(
                isExpanded: ReFreshTown.value,
                // عناصر اللست وهم محتويات القائمة
                items: _addDividersAfterItems(TownList, selectedTown),

                hint: Text(
                  "${AppLocalizations.of(context)!.select_town}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor),
                ),
                customItemsHeights: _getCustomItemsHeights(TownList),
                // حجم الإطار حول العنصر في القائمة
                // customItemsHeights: 10,
                // القيمة التي يأخذها الحقل الأساسي لقائمة وهو قيمة الخيار
                value: SelectedTownHelper,
                onChanged: (value) {
                  ReFreshTown(!ReFreshTown.value);
                  selectedTown(value.toString());
                  SelectedTownHelper = selectedTown.value;
                  registerController.TownIndex(CountryList[registerController.CountryIndex.value].city[registerController.CityIndex.value].region.lastIndexWhere((town) =>town.name ==  selectedTown.value));
                },

                // زر القائمة عندما تكون مغلقة
                icon: Icon(
                  Icons.arrow_drop_down,
                ),

                // زر القائمة عندما تكون مفتوحة
                iconOnClick: Icon(
                  Icons.arrow_drop_up,
                ),
                iconSize: 30,

                // تنسيق الحقل
                buttonHeight: 60,
                iconDisabledColor: Theme.of(context).primaryColor,
                iconEnabledColor: Theme.of(context).primaryColor,
                buttonPadding:
                const EdgeInsets.only(left: 10, right: 10),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                buttonElevation: 4,

                //تنسيق العنصر داخل القائمة
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 7, right: 7),
                selectedItemHighlightColor: Color(0xff189AB4),

                // تنسيق القائمة
                // dropdownWidth: MediaQuery.of(context).size.width * .95,
                dropdownPadding:
                const EdgeInsets.only(left: 10, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                dropdownElevation: 8,
                enableFeedback: true,
                scrollbarRadius: const Radius.circular(40),
                // مكان القائمة عندما تفتح بالنسبة للزر
                offset: Offset(0, 5),
                scrollbarAlwaysShow: true,
                scrollbarThickness: 10,
                dropdownMaxHeight: 200,
                searchController: registerController.textEditingTownController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    controller: registerController.textEditingTownController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: '${AppLocalizations.of(context)!.write_to_search}',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value
                      .toString()
                      .contains(searchValue));
                },
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    registerController.textEditingTownController.clear();
                  }
                },
              ):Container(width: 0,height: 0,);
            },
          ),
        ): Container(),
        SizedBox(
          height: 17,
        ),
        DropdownButtonHideUnderline(
          child: Obx(
                () {List<String> GenderList = [
                  "${AppLocalizations.of(context)!.male}",
                   "${AppLocalizations.of(context)!.female}"
                  ];
              return DropdownButton2(
                isExpanded: ReFreshGender.value,
                // عناصر اللست وهم محتويات القائمة
                items: _addDividersAfterItems(
                    GenderList, selectedGender),

                hint: Text(
                  "${AppLocalizations.of(context)!.select_gender}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor),
                ),
                customItemsHeights:
                _getCustomItemsHeights(GenderList),
                // حجم الإطار حول العنصر في القائمة
                // customItemsHeights: 10,
                // القيمة التي يأخذها الحقل الأساسي لقائمة وهو قيمة الخيار
                value: SelectedGenderHelper,
                onChanged: (value) {
                  ReFreshGender(!ReFreshGender.value);
                  selectedGender(value.toString());
                  SelectedGenderHelper = selectedGender.value;
                  registerController.userGender = selectedGender.value;
                },

                // زر القائمة عندما تكون مغلقة
                icon: Icon(
                  Icons.arrow_drop_down,
                ),

                // زر القائمة عندما تكون مفتوحة
                iconOnClick: Icon(
                  Icons.arrow_drop_up,
                ),
                iconSize: 30,

                // تنسيق الحقل
                buttonHeight: 60,
                iconDisabledColor: Theme.of(context).primaryColor,
                iconEnabledColor: Theme.of(context).primaryColor,
                buttonPadding:
                const EdgeInsets.only(left: 10, right: 10),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                buttonElevation: 4,

                //تنسيق العنصر داخل القائمة
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 7, right: 7),
                selectedItemHighlightColor: Color(0xff189AB4),

                // تنسيق القائمة
                // dropdownWidth: MediaQuery.of(context).size.width * .95,
                dropdownPadding:
                const EdgeInsets.only(left: 10, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                dropdownElevation: 8,
                enableFeedback: true,
                scrollbarRadius: const Radius.circular(40),
                // مكان القائمة عندما تفتح بالنسبة للزر
                offset: Offset(0, 5),
                scrollbarAlwaysShow: true,
                scrollbarThickness: 10,
                dropdownMaxHeight: 200,
              );
            },
          ),
        ),
        SizedBox(
          height: 17,
        ),
        Obx(() {
          return ElevatedButton(
            onPressed: () async {
              selectedBirthDate(
                registerController.dateOfBirth =  (await showDatePicker(
                  context: context,
                  initialDate: selectedBirthDate.value.year != 1907 ? selectedBirthDate.value : DateTime.now(),
                  firstDate: DateTime(1940),
                  lastDate: DateTime.now(),
                ))!,);
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(10, 60)),
              maximumSize: MaterialStateProperty.all<Size>(Size(400, 60)),
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Theme.of(context).scaffoldBackgroundColor),
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    side: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedBirthDate.value.year != 1907
                    ? Text(
                  DateFormat('dd/MM/yyyy').format(selectedBirthDate.value),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme ==
                        ColorScheme.light()
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                  ),
                )
                    : Text(
                  "${AppLocalizations.of(context)!.select_date_of_birth}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                  ),
                ),
                Icon(
                  Icons.date_range_outlined,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          );
        }),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
                child:  ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                    maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                  ),
                  onPressed: () {
                    GoToFirstPage(true);
                    GoToSecondPage(false);

                  },
                  child: Text(
                    "${AppLocalizations.of(context)!.previous}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ),
            Flexible(
              flex: 1,
              child:  ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                  maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                ),
                onPressed: () {
                  if(selectedCountry.value=='')
                    loadingMessage.DisplayError(
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor,
                        'Select your country',
                        true);
                  else if(selectedCity.value==''&&CityFieldIsAvilable.value)
                    loadingMessage.DisplayError(
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor,
                        'Select your city',
                        true);
                  else if(selectedTown.value==''&&TownFieldIsAvilable.value)
                    loadingMessage.DisplayError(
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor,
                        'Select your Town',
                        true);
                  else{
                    // print(registerController.CountryIndex);
                    print(registerController.CityIndex);
                    // print(registerController.TownIndex);
                    GoToSecondPage(false);
                    GoToLAstPage(true);
                  }

                },
                child: Text(
                  "${AppLocalizations.of(context)!.next}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),

        SizedBox(
          height: 25,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.go_to),
              GestureDetector(
                onTap: () {
                  // print(registerController.country);
                  Get.toNamed('/login');
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
        SizedBox(
          height: 25,
        )
      ],
    );
  }

  Widget BuildLastWidget(BuildContext context){
    return Form(
      key: formKay2,
      child: ListView(
        children: [

          SizedBox(
            height: 17,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            maxLines: 1,
            controller: telephoneNumberController,
            decoration: InputDecoration(
              labelText: "${AppLocalizations.of(context)!.telephone_number}",

            ),
            onSaved: (value){
              registerController.telephoneNumber = value!;
            },
          ),

          SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: DropdownButtonHideUnderline(
                    child: Obx(
                          () {
                        return DropdownButton2(
                          isExpanded: ReFreshCodePhone.value,
// عناصر اللست وهم محتويات القائمة
                          items: _addDividersAfterItems(
                              countryCodePhoneList, selectedCodePhone),

                          hint: Text(
                            "${AppLocalizations.of(context)!.code}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,),
                          ),
                          customItemsHeights:
                          _getCustomItemsHeights(countryCodePhoneList),
// حجم الإطار حول العنصر في القائمة
// customItemsHeights: 10,
// القيمة التي يأخذها الحقل الأساسي لقائمة وهو قيمة الخيار
                          value: SelectedCodePhoneHelper,
                          onChanged: (value) {
                            ReFreshCodePhone(!ReFreshCodePhone.value);
                            selectedCodePhone(value.toString());
                            SelectedCodePhoneHelper = selectedCodePhone.value;
                            registerController.countryCodeNumber = selectedCodePhone.value;
                          },

// زر القائمة عندما تكون مغلقة
                          icon: Icon(
                            Icons.arrow_drop_down,
                          ),

// زر القائمة عندما تكون مفتوحة
                          iconOnClick: Icon(
                            Icons.arrow_drop_up,
                          ),
                          iconSize: 30,

// تنسيق الحقل
                          buttonHeight: 70,
                          buttonWidth: MediaQuery.of(context).size.width * .3,
                          iconDisabledColor:
                          Theme.of(context).primaryColor,
                          iconEnabledColor:
                          Theme.of(context).primaryColor,
                          buttonPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            color:
                            Theme.of(context).scaffoldBackgroundColor,
                          ),
                          buttonElevation: 4,

//تنسيق العنصر داخل القائمة
                          itemHeight: 40,
                          itemPadding:
                          const EdgeInsets.only(left: 7, right: 7),
                          selectedItemHighlightColor: Color(0xff189AB4),

// تنسيق القائمة
// dropdownWidth: MediaQuery.of(context).size.width * .2,
                          dropdownPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            color:
                            Theme.of(context).scaffoldBackgroundColor,
                          ),
                          dropdownElevation: 8,
                          enableFeedback: true,
                          scrollbarRadius: const Radius.circular(40),
// مكان القائمة عندما تفتح بالنسبة للزر
                          offset: Offset(0, 5),
                          scrollbarAlwaysShow: true,
                          scrollbarThickness: 10,
                          dropdownMaxHeight: 200,

                        );
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "${AppLocalizations.of(context)!.phone_number}",

                  ),
                  maxLength: 9,
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    registerController.phoneNumber = value!;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 17,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            maxLines: 1,
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "${AppLocalizations.of(context)!.description_about_your_location}",
            ),
            onSaved: (value){
              registerController.locationDescription = value!;
            },
          ),
          SizedBox(
            height: 17,
          ),
          Row(
            children: [
              Text('${AppLocalizations.of(context)!.remember_me}',style: TextStyle(fontSize: 15),),
              SizedBox(width: 10,),
              Obx((){
                return  GestureDetector(
                  onTap:() {
                    IsSave(!IsSave.value);
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Theme.of(context).primaryColor,width: 3),
                        color: IsSave.value == false ? Theme.of(context).scaffoldBackgroundColor:Theme.of(context).primaryColor
                    ),
                    child: Icon(Icons.check , color: IsSave.value == false ? Theme.of(context).scaffoldBackgroundColor:Colors.white,size: 17,),
                  ),
                );
              }),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child:  ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                    maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                  ),
                  onPressed: () {
                    GoToSecondPage(true);
                    GoToLAstPage(false);

                  },
                  child: Text(
                    "${AppLocalizations.of(context)!.previous}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child:  ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                    maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * .4, 50)),
                  ),
                  onPressed: () {
                    final isValid = formKay2.currentState?.validate();
                    if (isValid == true) {
                      formKay2.currentState?.save();
                      if(IsSave.value){
                        registerController.sharedData.SaveEmail(registerController.email);
                        registerController.sharedData.SavePassword(registerController.password);
                      }
                      OnClickRegister(context);
                    }
                  },
                  child: Text(
                    "${AppLocalizations.of(context)!.register}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.go_to),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/login');
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
          SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}



