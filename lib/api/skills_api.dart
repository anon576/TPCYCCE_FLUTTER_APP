import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/share_prefs.dart';

class SkillAPI {
  static Future<Map<String, dynamic>> createSkill(String skill, int level) async {
  try {
    final id = await SharePrefs.readPrefs('id', 'int');
    String token = await SharePrefs.readPrefs("token", "string");

    if (id == null) {
      return {
        "success": false,
        "message": "Student ID not found"
      };
    }

    print(id);

    final response = await http.post(
      Uri.parse('$apilink/skill/create'),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'Skill': skill,
        'Level': level,
        'StudentID': id,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      return {
        "success": false,
        "message": "Skill, Level, and StudentID are required."
      };
    } else if (response.statusCode == 409) {
      return {
        "success": false,
        "message": "Skill already exists for this student."
      };
    } else if (response.statusCode == 500) {
      return {
        "success": false,
        "message": "An error occurred while creating the skill."
      };
    } else {
      return {
        "success": false,
        "message": "Failed to create skill. Status code: ${response.statusCode}"
      };
    }
  } catch (error) {
    return {
      "success": false,
      "message": "Error creating skill"
    };
  }
}

  static Future<Map<String, dynamic>> updateSkill(int skillId, String skill, int level) async {
    try {
      String token = await SharePrefs.readPrefs("token", "string");

      final response = await http.put(
        Uri.parse('$apilink/skill/update/$skillId'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'SkillId': skillId,
          'Skill': skill,
          'Level': level,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": responseData['message'] ?? "Skill updated successfully"
        };
      } else if (response.statusCode == 400) {
        return {
          "success": false,
          "message": responseData['message'] ?? "SkillId, Skill, and Level are required."
        };
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "message": responseData['message'] ?? "Skill not found."
        };
      } else if (response.statusCode == 500) {
        return {
          "success": false,
          "message": responseData['message'] ?? "Failed to update skill."
        };
      } else {
        return {
          "success": false,
          "message": "Unexpected error. Status code: ${response.statusCode}"
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "Error updating skill"
      };
    }
  }

  static Future<Map<String, dynamic>> deleteSkill(int skillId) async {
    try {
      String token = await SharePrefs.readPrefs("token", "string");

      final response = await http.delete(
        Uri.parse('$apilink/skill/delete/$skillId'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": responseData['message'] ?? "Skill deleted successfully"
        };
      } else if (response.statusCode == 400) {
        return {
          "success": false,
          "message": responseData['message'] ?? "SkillId is required."
        };
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "message": responseData['message'] ?? "Skill not found."
        };
      } else {
        return {
          "success": false,
          "message": responseData['message'] ?? "Failed to delete skill. Status code: ${response.statusCode}"
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "Error deleting skill"
      };
    }
  }

  static Future<Map<String, dynamic>> readSkills() async {
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
        Uri.parse('$apilink/skill/read?StudentId=$id'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "message": "No skills found for this student."
        };
      } else if (response.statusCode == 400) {
        return {
          "success": false,
          "message": "StudentId is required."
        };
      } else {
        return {
          "success": false,
          "message": "Failed to load skills. Status code: ${response.statusCode}"
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "Error fetching skills: ${error.toString()}"
      };
    }
  }
}
