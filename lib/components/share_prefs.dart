import "package:shared_preferences/shared_preferences.dart";

class SharePrefs {
  static void storePrefs(String key, dynamic value, String type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (type == "int") {
      await sp.setInt(key, value);
    } else if (type == "string") {
      await sp.setString(key, value);
    } else if (type == "bool") {
      await sp.setBool(key, value);
    }
  }

  static dynamic readPrefs(String key, String type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    dynamic value;
    if (type == "int") {
      value = await sp.getInt(key);
    } else if (type == "string") {
      value = await sp.getString(key);
    } else if (type == "bool") {
      value = await sp.getBool(key);
    }

    return value;
  }

  static Future<bool> clearPrefs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isclear = await sp.clear();
    return isclear;
  }

  static void storeUserInfo(Map<String, dynamic> data) {
   print(data['id'].runtimeType);
    SharePrefs.storePrefs("id", data['id'], 'int');
      print("here");
    SharePrefs.storePrefs("branch", data['Branch'].toString(), 'string');
    SharePrefs.storePrefs("sec", data['Section'].toString(), 'string');
    SharePrefs.storePrefs("regno", data['College ID'].toString(), 'string');
    SharePrefs.storePrefs("dob", data['DoB'].toString(), 'string');
    SharePrefs.storePrefs(
        "college_mail", data['College MailID'].toString(), 'string');
    SharePrefs.storePrefs("password", data['password'].toString(), 'string');
    SharePrefs.storePrefs(
        "student_name", data['Name of Student'].toString(), 'string');
    SharePrefs.storePrefs("gender", data['Gender'].toString(), 'string');
    SharePrefs.storePrefs("dob", data['DoB'].toString(), 'string');
    SharePrefs.storePrefs("ssc_yop", data['SSC YOP'].toString(), 'string');
    SharePrefs.storePrefs(
        "ssc_percentage", data['SSC %age'].toString(), 'string');
    SharePrefs.storePrefs("hsc_yop", data['HSC YoP'].toString(), 'string');
    SharePrefs.storePrefs(
        "hssc_percentage", data['HSSC %age'].toString(), 'string');
    SharePrefs.storePrefs("sgpa1", data['SGPA1'].toString(), 'string');
    SharePrefs.storePrefs("sgpa2", data['SGPA2'].toString(), 'string');
    SharePrefs.storePrefs("sgpa3", data['SGPA3'].toString(), 'string');
    SharePrefs.storePrefs("sgpa4", data['SGPA4'].toString(), 'string');
    SharePrefs.storePrefs("sgpa5", data['SGPA5'].toString(), 'string');
    SharePrefs.storePrefs("sgpa6", data['SGPA6'].toString(), 'string');
    SharePrefs.storePrefs("sgpa7", data['SGPA7'].toString(), 'string');
    SharePrefs.storePrefs("avg_sgpa", data['Avg. SGPA'].toString(), 'string');
    SharePrefs.storePrefs("mobile1", data['Mobile 1'].toString(), 'string');
    SharePrefs.storePrefs("mobile2", data['Mobile 2'].toString(), 'string');
    SharePrefs.storePrefs("mobile3", data['Mobile 3'].toString(), 'string');
    SharePrefs.storePrefs(
        "personal_email", data['Personal Email Address'].toString(), 'string');
  }
}
