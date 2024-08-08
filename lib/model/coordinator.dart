import 'package:yccetpc/api/co_api.dart';
import 'package:yccetpc/components/route.dart';

import '../components/error_snackbar.dart';
import '../components/share_prefs.dart';

class Coordinator{
 
  static Future<void> login(String email, String password,context) async {
    try {
      Map<dynamic, dynamic> user = await CoAPI.login(
        email,password);
       
      if(user['success']){
        SharePrefs.storePrefs("isLogin", true, "bool");
        SharePrefs.storePrefs("role", "coordinator", "string");
        RouterClass.ReplaceScreen(context, "/coscreen");
      }else{
        InputComponent.showWarningSnackBar(context, user['message']);
      }
    } catch (e) {
      InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }
}