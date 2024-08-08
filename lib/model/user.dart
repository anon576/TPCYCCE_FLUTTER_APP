import 'package:yccetpc/components/error_snackbar.dart';
import 'package:yccetpc/components/route.dart';
import 'package:yccetpc/components/share_prefs.dart';
import 'package:yccetpc/screen/SignUP/new_password.dart';

import '../api/user_api.dart';

class User {
  static Future<void> login(String email, String password,context) async {
    try {
      Map<dynamic, dynamic> user = await UserApi.login(
        email,password);
       
      if(user['success']){
        if(user['new_user']){
          RouterClass.AddScreen(context, const NewPassword());     
        }else{
           print("here");
          RouterClass.ReplaceScreen(context, "/home");
        }
      }else{
        InputComponent.showWarningSnackBar(context, user['message']);
      }
    } catch (e) {
      InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }

  static Future<void> update_password(String password,context)async{
    try{
      print(password);
       Map<dynamic, dynamic> user = await UserApi.updatePassword(password);
      if(user['success']){
        SharePrefs.storePrefs("isLogin", true, "bool");
        SharePrefs.storePrefs("role", "student", "string");
        RouterClass.ReplaceScreen(context, "/home");
      }else{
        InputComponent.showWarningSnackBar(context, user['message']);
      }
    }catch(e){
       InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }

  static Future<bool> forget_password(String email,context)async{
    try{
       Map<dynamic, dynamic> user = await UserApi.forgetPassword(email);
       if(user['success']){
        return user['success'];
       }else{
         InputComponent.showWarningSnackBar(context, user['message']);
       }
       return user['success'];
    }catch(e){
       InputComponent.showWarningSnackBar(context, "Something went wrong");
       return false;
    }
  }

  static void check_otp(int otp,context)async{
    try{
      
      int actual_otp =await SharePrefs.readPrefs('otp', 'int');
      if(actual_otp==otp){
        print(actual_otp);
           RouterClass.AddScreen(context, NewPassword());
      }else{
         InputComponent.showWarningSnackBar(context, "OTP galat hai!");
      }
    }catch(e){
       InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }
}
