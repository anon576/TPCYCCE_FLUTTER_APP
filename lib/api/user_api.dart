import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yccetpc/components/share_prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../components/app_properties.dart';

class UserApi {
  static late FirebaseMessaging _firebaseMessaging;

  static Future<Map<dynamic, dynamic>> login(
      String email, String password) async {

        
    _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await _firebaseMessaging.getToken();
    Map<String, dynamic> userData = {
      "email": email,
      "password": password,
      "mtoken": fcmToken
    };

    String jsonData = jsonEncode(userData);
    Uri apiUrl = Uri.parse('$apilink/auth/student_login');

    try {
      http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      if (response.statusCode == 200) {
        SharePrefs.storePrefs("college_mail", email, 'string');
        SharePrefs.storePrefs("isLogin", true, "bool");
        SharePrefs.storePrefs("role", "student", "string");

        dynamic responseData = jsonDecode(response.body);

        SharePrefs.storeUserInfo(responseData['user']);
        SharePrefs.storePrefs("token", responseData['token'], "string");

        Map<dynamic, dynamic> data = responseData;
        return data;
      } else if (response.statusCode == 401) {
        print('Incorrect password. Status code: ${response.statusCode}');
        Map<dynamic, dynamic> data = {
          "success": false,
          "message": "Incorrect password"
        };
        return data;
      } else if (response.statusCode == 404) {
        // User not found
        print('User not found. Status code: ${response.statusCode}');
        Map<dynamic, dynamic> data = {
          "success": false,
          "message": "User not found"
        };
        return data;
      } else if (response.statusCode == 500) {
        // Internal server error
        print('Internal server error. Status code: ${response.statusCode}');
        Map<dynamic, dynamic> data = {
          "success": false,
          "message": "Internal server error"
        };
        return data;
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        Map<dynamic, dynamic> data = {
          "success": false,
          "message": "Failed to send data. Status code: ${response.statusCode}"
        };
        return data;
      }
    } catch (error) {
      print('Error sending data: $error');
      Map<dynamic, dynamic> data = {
        "success": false,
        "message": "Error sending data"
      };
      return data;
    }
  }

  static Future<Map<dynamic, dynamic>> updatePassword(String password) async {
    try {
       _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await _firebaseMessaging.getToken();
      String email = await SharePrefs.readPrefs('college_mail', 'string');

      if (email.isEmpty || password.isEmpty) {
        return {
          'status': 'error',
          'message': 'Email and password are required',
        };
      }

      final response = await http.post(
        Uri.parse('$apilink/auth/student_update_password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          "mtoken":fcmToken
        }),
      );

      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        SharePrefs.storePrefs("token", responseData['token'], "string");
        return {
          'success': true,
          'message': 'Password updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Internal server error',
        };
      }
    } catch (e) {
      print('Error updating password: $e');
      return {
        'status': 'error',
        'message': 'An error occurred while updating the password',
      };
    }
  }

  static Future<Map<String, dynamic>> forgetPassword(String email) async {
    final url = Uri.parse('$apilink/auth/student_forget_password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        SharePrefs.storePrefs('otp', int.parse(responseData['otp']), 'int');
        SharePrefs.storePrefs("college_mail", email, 'string');
        SharePrefs.storeUserInfo(responseData['user']);
        return {
          'success': true,
          'message': 'OTP has been sent to your email',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'User with this email does not exist',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred',
      };
    }
  }
}
