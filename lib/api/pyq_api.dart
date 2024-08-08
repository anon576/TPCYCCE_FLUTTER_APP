import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/share_prefs.dart';
import '../model/PYQ.dart';


class PYQAPI{
  static Future<Map<String, dynamic>> fetchCodePYQ(int campus_id) async {
    try {
      String token = await SharePrefs.readPrefs("token", "string");

      final response = await http.get(
        Uri.parse('$apilink/pyq/code?campusId=${campus_id}'),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['codingQuestions'];
       
        List<PYQ> pyqs = data.map((item) => PYQ(
          question: item['Question'],
          sampleInput: item['SampleInput'],
          sampleOutput: item['SampleOutput'],
          explanation: item['Explanation'],
          program: item['Code'],
        )).toList();
        print(pyqs[0].question);
        return {
          'success': true,
          'data': pyqs,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load data. Status code: ${response.statusCode}',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Error fetching data: $error',
      };
    }
  }


   static Future<Map<String, dynamic>> fetchInterviewQuestions(int campusId) async {
    try {
      String token = await SharePrefs.readPrefs("token", "string");
      final response = await http.get(
        Uri.parse('$apilink/pyq/interview?campusID=$campusId'),
        headers: {
          'Authorization': '$token',
        },
  
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<InterviewQuestion> interview_question = data.map((item) => InterviewQuestion(
          question: item['Question'],
          answer: item['Answer']
        )).toList();
        return {
          'success': true,
          'data': interview_question,
        };
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "message": "Interview questions not found"
        };
      } else {
        return {
          "success": false,
          "message": "Failed to load interview questions. Status code: ${response.statusCode}"
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "Error fetching interview questions"
      };
    }
  }


static Future<Map<String, dynamic>> fetchAptitudeQuestions(int campusId) async {
  try {
    String token = await SharePrefs.readPrefs("token", "string");
    final response = await http.get(
      Uri.parse('$apilink/pyq/apti?campusId=$campusId'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['aptiLRQuestions'];
      List<AptitudeQuestion> apti = data.map((item) {
                return AptitudeQuestion(
                  question: item['Question'],
                  options: [
                    item['Option1'],
                    item['Option2'],
                    item['Option3'],
                    item['Option4'],
                  ],
                  answer: item['Answer'],
                  explanation: item['Explanation'],
                );
              }).toList();

      return {
        "success": true,
        "data": apti,
      };
    } else if (response.statusCode == 404) {
      return {
        "success": false,
        "message": "Aptitude questions not found"
      };
    } else {
      return {
        "success": false,
        "message": "Failed to load aptitude questions. Status code: ${response.statusCode}"
      };
    }
  } catch (error) {
    return {
      "success": false,
      "message": "Error fetching aptitude questions"
    };
  }
}


static Future<Map<String, dynamic>> markSeen(String pyq, int campusId) async {
    try {
      final id = await SharePrefs.readPrefs('id', 'int');
      String token = await SharePrefs.readPrefs("token", "string");

      if (id == null) {
        return {
          "success": false,
          "message": "Student ID not found"
        };
      }

      // Prepare the request
      final response = await http.post(
        Uri.parse('$apilink/pyq/mark_seen'),
        body: jsonEncode({
          'studentId': id,
          'pyq': pyq,
          'campusId': campusId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token, 
        },
      );

      // Check if the response was successful
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        return {
          "success": true,
          "data": responseData
        };
      } else {
       print(response.body);
        return {
          "success": false,
          "message": "Failed to mark as seen. Status code: ${response.statusCode}",
          "error": jsonDecode(response.body)
        };
      }
    } catch (error) {
      // Handle any errors that occur during the request
      return {
        "success": false,
        "message": "Error fetching data",
        "error": error.toString()
      };
    }
  }
}