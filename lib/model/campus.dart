import 'package:yccetpc/api/campus_api.dart';

import '../components/error_snackbar.dart';

class Campus{

   static Future<void> getCampus(String email, String password,context) async {
    try {
      Map<dynamic, dynamic> user = await CampusAPI.fetchCampus();
       
      if(user['success']){
        return user['campus'];
      }else{
        InputComponent.showWarningSnackBar(context, user['message']);
      }
    } catch (e) {
      InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }


}