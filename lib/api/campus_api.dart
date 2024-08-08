import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/share_prefs.dart';

class CampusAPI{

static Future<Map<String, dynamic>> fetchCampus() async {
    try {
      final id = await SharePrefs.readPrefs('id', 'int');
      String token = await SharePrefs.readPrefs("token", "string");
      if (id == null) {
        return {
          "success": false,
          "message": "Student ID not found"
        };
      }

       final response = await http.get(
      Uri.parse('$apilink/student/get_campus/$id'),
      headers: {
        'Authorization': '$token', 
       
      },
    );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "message": "Student not found"
        };
      } else {
        return {
          "success": false,
          "message": "Failed to load campus data. Status code: ${response.statusCode}"
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "Error fetching data"
      };
    }
  }

  static Future<Map<String, dynamic>> cofetchCampus() async {
    try {
       String token = await SharePrefs.readPrefs("token", "string");
      final response = await http.get(Uri.parse('$apilink/coordinator/get_campus'),
      headers: {
        'Authorization': '$token', 
       
      },);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Failed to load campus data. Status code: ${response.statusCode}"
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "Error fetching data"
      };
    }
  }


}