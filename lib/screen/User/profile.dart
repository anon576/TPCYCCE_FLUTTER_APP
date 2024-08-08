import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';
import 'package:yccetpc/components/route.dart';
import 'package:yccetpc/screen/User/academic.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String gender = '';
  String personalEmail = '';
  String mobile1 = '';
  String collegeMail = '';
  String branch = '';
  String sec = '';
  String regno = '';
  String dob = '';
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      dob = sp.getString("dob") ?? '';
      regno = sp.getString("regno") ?? '';
      name = sp.getString('student_name') ?? '';
      gender = sp.getString('gender') ?? '';
      personalEmail = sp.getString('personal_email') ?? '';
      mobile1 = sp.getString('mobile1') ?? '';
      collegeMail = sp.getString('college_mail') ?? '';
      branch = sp.getString('branch') ?? '';
      sec = sp.getString('sec') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Profile", context),
      backgroundColor: BackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: CardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'assets/user.png'), // Add a profile image
                      ),
                      SizedBox(height: 10),
                      Text(
                        name,
                        style: TextStyle(
                          color: TextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        branch,
                        style: TextStyle(color: TextColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: CardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email,color: TextColor),
                          SizedBox(width: 10),
                          Text(
                            "Section : " + sec,
                            style: TextStyle(fontSize: 16,color: TextColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone,color: TextColor),
                          SizedBox(width: 10),
                          Text(
                            "College ID : " + regno,
                            style: TextStyle(fontSize: 16,color: TextColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email,color: TextColor),
                          SizedBox(width: 10),
                          Text(
                            "Gender : " + gender,
                            style: TextStyle(fontSize: 16,color: TextColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email,color: TextColor),
                          SizedBox(width: 10),
                          Text(
                            "DOB : " + dob,
                            style: TextStyle(fontSize: 16,color: TextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: CardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone,color: TextColor),
                          SizedBox(width: 10),
                          Text(
                            mobile1,
                            style: TextStyle(fontSize: 16,color: TextColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email,color: TextColor),
                          SizedBox(width: 10),
                          Text(
                            personalEmail,
                            style: TextStyle(fontSize: 16,color: TextColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email,color: TextColor),
                          const SizedBox(width: 10),
                          Text(
                            collegeMail,
                            style: TextStyle(fontSize: 16,color: TextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Card(
                  color: CardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      'Academic Details',
                      style: TextStyle(color: Colors.blue),
                    ),
                    trailing: Icon(Icons.arrow_forward, color: Colors.blue),
                    onTap: () {
                      RouterClass.AddScreen(context, AcademicDetailsScreen());
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
