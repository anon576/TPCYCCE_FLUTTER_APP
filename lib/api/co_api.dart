import 'dart:convert';

import 'package:http/http.dart' as http;

import '../components/app_properties.dart';
import '../components/share_prefs.dart';

class CoAPI {
  static Future<Map<dynamic, dynamic>> login(String id, String password) async {
    Map<String, dynamic> userData = {"id": id, "password": password};

    String jsonData = jsonEncode(userData);
    Uri apiUrl = Uri.parse('$apilink/auth/co_login');

    try {
      http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      if (response.statusCode == 200) {
        SharePrefs.storePrefs("id", id, 'string');
        dynamic responseData = jsonDecode(response.body);
        SharePrefs.storePrefs("token", responseData['token'], "string");
        SharePrefs.storePrefs("name", responseData['user']['name'], "string");
        SharePrefs.storePrefs('cID', responseData['user']['cID'], 'int');

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
}
