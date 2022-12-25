import 'package:shared_preferences/shared_preferences.dart';

class SharedData{
  ///////////// token
   Future<void> SaveToken(String Token)async{
    final data = await SharedPreferences.getInstance();
    data.setString('token', Token);
  }

  Future<String> GetToken()async{
    final data = await SharedPreferences.getInstance();
    String? token = data.getString('token');
    return token ?? '';
  }
  Future<bool> DeleteToken ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('token'))
      return true;
    return false;
  }

  ///////////// UserID
   Future<void> SaveUserID(int UserID)async{
    final data = await SharedPreferences.getInstance();
    data.setInt('user_id', UserID);
  }

  Future<int> GetUserID()async{
    final data = await SharedPreferences.getInstance();
    int? UserID = data.getInt('user_id');
    return UserID ?? -1;
  }
  Future<bool> DeleteUserID ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('user_id'))
      return true;
    return false;
  }


  /////////////////// temporary email  'to use in send email in resend PIN'
  Future<void> SaveTemporaryEmail(String TEmail)async{
    final data = await SharedPreferences.getInstance();
    data.setString('temporary_email', TEmail);
  }

  Future<String> GetTemporaryEmail()async{
    final data = await SharedPreferences.getInstance();
    String? TEmail = data.getString('temporary_email');
    return TEmail ?? '';
  }
  Future<bool> DeleteTemporaryEmail ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('temporary_email'))
      return true;
    return false;
  }

  /////////////////// Temporary password  'to use in send email in resend PIN'
  Future<void> SaveTemporaryPassword(String TEmail)async{
    final data = await SharedPreferences.getInstance();
    data.setString('temporary_password', TEmail);
  }

  Future<String> GetTemporaryPassword()async{
    final data = await SharedPreferences.getInstance();
    String? TEmail = data.getString('temporary_password');
    return TEmail ?? '';
  }
  Future<bool> DeleteTemporaryPassword ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('temporary_password'))
      return true;
    return false;
  }

  /////////////////// email
  Future<void> SaveEmail(String Email)async{
    final data = await SharedPreferences.getInstance();
    data.setString('email', Email);
  }

  Future<String> GetEmail()async{
    final data = await SharedPreferences.getInstance();
    String? Email = data.getString('email');
    return Email ?? '';
  }
  Future<bool> DeleteEmail ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('email'))
      return true;
    return false;
  }

  /////////////////// password
  Future<void> SavePassword(String password)async{
    final data = await SharedPreferences.getInstance();
    data.setString('password', password);
  }

  Future<String> GetPassword()async{
    final data = await SharedPreferences.getInstance();
    String? password = data.getString('password');
    return password ?? '';
  }
  Future<bool> DeletePassword ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('password'))
      return true;
    return false;
  }

  /////////////////// app language
  Future<void> SaveAppLanguage(String AppLanguage)async{
    final data = await SharedPreferences.getInstance();
    data.setString('app_language', AppLanguage);
  }

  Future<String?> GetAppLanguage()async{
    final data = await SharedPreferences.getInstance();
    String? AppLanguage = data.getString('app_language');
    return AppLanguage ;
  }
  Future<bool> DeleteAppLanguage ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('app_language'))
      return true;
    return false;
  }

   /////////////////// app Theme Mode

   Future<void> SaveAppThemeModeIsDark(bool AppThemeModeIsDark)async{
     final data = await SharedPreferences.getInstance();
     data.setBool('app_theme_mode_is_dark', AppThemeModeIsDark);
   }

   Future<bool?> GetAppThemeModeIsDark()async{
     final data = await SharedPreferences.getInstance();
     bool? AppThemeModeIsDark = data.getBool('app_theme_mode_is_dark');
     return AppThemeModeIsDark ;
   }
   Future<bool> DeleteAppThemeModeIsDark ()async{
     final data = await SharedPreferences.getInstance();
     if(await data.remove('app_theme_mode_is_dark'))
       return true;
     return false;
   }


}