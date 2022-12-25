import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;
}




class MyThemes {

  //////////////////// light color //////////////////////////////

  // App bar
  static final AppBarBackgroundWightColor = Color(0xff076579);
  static final AppBarTitleWightColor = Color(0xffFAFAFA);
  static final AppBarIconWightColor = Color(0xffFAFAFA);

  // scaffold
  static final ScaffoldBackgroundWightColor = Color(0xfff5f6f6);

  // Bottom Bar
  static final BottomBarBackgroundWightColor = Color(0xff076579);
  static final UnselectedItemColor = Color(0xff9ad5e1);
  static final SelectedItemColor = Colors.white;






  static final mainLightColor = Color(0xff076579);//Color(0xff05445E)
  static final secondlyLightColor = Color(0xff017b91);
  static final mainDarkColor = Color(0xff017b91);
  static final secondlyDarkColor = Color(0xff9ad5e1);
  static final IconColor = Colors.white;





  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: ScaffoldBackgroundWightColor,

    colorScheme: ColorScheme.light(), //text color
    fontFamily: "Cairo",
    primaryColor: mainLightColor, //color we can use when we need


    iconTheme: IconThemeData(color: mainLightColor , size: 20),


    appBarTheme: AppBarTheme(
      backgroundColor: AppBarBackgroundWightColor,

      titleTextStyle: TextStyle(color: AppBarTitleWightColor , fontSize: 30,fontFamily:  "Cairo"),
      actionsIconTheme: IconThemeData(
        color: AppBarIconWightColor,
        size: 30
      ),
      iconTheme: IconThemeData(
        color: AppBarIconWightColor,
        size: 30,
      ),

    ),




    inputDecorationTheme: InputDecorationTheme(


      labelStyle: TextStyle(
        color: mainLightColor,
      ),

      enabledBorder:  OutlineInputBorder(
        borderSide: BorderSide(
            color: mainLightColor,
            width: 2
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      suffixIconColor: mainLightColor,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.red,
            width: 2
        ),
        borderRadius: BorderRadius.circular(8),
      ),


        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: mainLightColor,
            width: 2
          ),

        borderRadius: BorderRadius.circular(8),
      ),


      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color:Colors.red,
            width: 3
        ),

        borderRadius: BorderRadius.circular(8),
      ),
      errorMaxLines: 1,

    ),
      elevatedButtonTheme: ElevatedButtonThemeData(

          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainLightColor),
            minimumSize: MaterialStateProperty.all<Size>(Size(10, 50)),
            maximumSize: MaterialStateProperty.all<Size>(Size(400, 50)),
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15),),),),
          )
      ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: BottomBarBackgroundWightColor,
      unselectedItemColor : UnselectedItemColor,
      selectedItemColor: SelectedItemColor,
    )

  );

////////////////////////////// Dark Color //////////////////////////////
  // App bar
  static final AppBarBackgroundDarkColor = Color(0xff1e1e1e);
  static final AppBarTitleDarkColor = Color(0xffFAFAFA);
  static final AppBarIconDarkColor = Color(0xffFAFAFA);

  // Scaffold
  static final ScaffoldBackgroundDarkColor = Color(0xff090909);

  // Bottom Bar
  static final BottomBarBackgroundDarkColor = Color(0xff1e1e1e);
  static final UnselectedItemDarkColor = Colors.white;
  static final SelectedItemDarkColor =  Color(0xff017b91);

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: ScaffoldBackgroundDarkColor,
    colorScheme: ColorScheme.dark(),
    fontFamily: "Cairo",
    //text color
    primaryColor: mainDarkColor,

    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: AppBarBackgroundDarkColor,
      titleTextStyle: TextStyle(color: AppBarTitleDarkColor,fontSize: 20,fontFamily: "Cairo"),
      actionsIconTheme: IconThemeData(
        color: AppBarIconDarkColor,
      ),
      iconTheme: IconThemeData(
        color: AppBarIconDarkColor,
      ),
    ),

    brightness: Brightness.dark,

    inputDecorationTheme: InputDecorationTheme (
      labelStyle: TextStyle(
        color: mainDarkColor,
      ),

      enabledBorder:  OutlineInputBorder(
        borderSide: BorderSide(
            color: mainDarkColor,
            width: 2
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      suffixIconColor: mainDarkColor,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.red,
            width: 2
        ),
        borderRadius: BorderRadius.circular(8),
      ),


      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: mainDarkColor,
            width: 2
        ),

        borderRadius: BorderRadius.circular(8),
      ),


      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color:Colors.red,
            width: 3
        ),

        borderRadius: BorderRadius.circular(8),
      ),
      errorMaxLines: 1,

    ),

      elevatedButtonTheme: ElevatedButtonThemeData(

          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainDarkColor),
            minimumSize: MaterialStateProperty.all<Size>(Size(10, 50)),
            maximumSize: MaterialStateProperty.all<Size>(Size(2000, 50)),
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15),),),),
          )
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: BottomBarBackgroundDarkColor,
        unselectedItemColor : UnselectedItemDarkColor,
        selectedItemColor: SelectedItemDarkColor,
      ),


  );


}
