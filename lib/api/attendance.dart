import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yccetpc/components/app_properties.dart';
import '../components/share_prefs.dart';
import '../database/database.dart';

class AttendanceAPI {
  static Future<Map<String, dynamic>> markAttendace(int roundId, int attendanceId) async {
    try {
       String token = await SharePrefs.readPrefs("token", "string");
      Uri apiUrl = Uri.parse('$apilink/attendance/update_attendance');

      Map<String, dynamic> userData = {"roundid": roundId, "attendanceid": attendanceId};

      String jsonData = jsonEncode(userData);
      // Make the HTTP PUT request
      http.Response response = await http.put(
        apiUrl,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: jsonData,
      );

      // Check the response status code and handle the response
      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Attendance marked successfully",
          "data": jsonDecode(response.body)
        };
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "message": "Record not found",
          "data": jsonDecode(response.body)
        };
      } else {
        await DatabaseHelper().insertFailedAttendance(roundId, attendanceId);
        return {
          "success": false,
          "message": "Failed to mark attendance: ${response.body}"
        };
      }
    } catch (error) {
      // Log the error
      print('Error: $error');

      // Store the failed attendance data in SQLite
      await DatabaseHelper().insertFailedAttendance(roundId, attendanceId);
      return {
        "success": false,
        "message": "Error fetching data"
      };
    }
  }
}
