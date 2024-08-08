// notification_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yccetpc/components/app_properties.dart';
import '../components/share_prefs.dart';

class NotificationAPI {
  static Future<Map<String, dynamic>> fetchNotificationById(int notificationId) async {
    try {
      String token = await SharePrefs.readPrefs("token", "string");
      Uri apiUrl = Uri.parse('$apilink/notification/fetch_notification/$notificationId');

      // Make the HTTP GET request
      http.Response response = await http.get(
        apiUrl,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
      );

      // Check the response status code and handle the response
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body)
        };
      } else {
        return {
          "success": false,
          "message": "Failed to fetch notification: ${response.body}"
        };
      }
    } catch (error) {
      // Log the error
      print('Error: $error');
      return {
        "success": false,
        "message": "Error fetching data"
      };
    }
  }
}
