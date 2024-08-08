import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/route.dart';
import 'package:yccetpc/components/share_prefs.dart';
import 'package:yccetpc/screen/Campus/backup.dart';
import 'package:yccetpc/screen/Campus/co_campus_screen.dart';
import 'package:yccetpc/screen/Campus/co_saved_campus.dart';
import 'package:yccetpc/screen/User/academic.dart';

import '../../database/database.dart';




class CoHomeScreen extends StatefulWidget {
  const CoHomeScreen({super.key});

  @override
  State<CoHomeScreen> createState() => _CoHomeScreenState();
}

class _CoHomeScreenState extends State<CoHomeScreen> {
 
String name = '';
  String branch = '';
  
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
     
      name = sp.getString('name') ?? '';

      branch = sp.getString('id') ?? '';
          
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TPC YCCE',style: TextStyle(color: TextColor),),
        backgroundColor: BackgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: TextColor,
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: BackgroundColor,
      drawer: Drawer(
        
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: BackgroundColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Backup'),
              onTap: () {
                RouterClass.AddScreen(context, BackupScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Logout'),
              onTap: () {
                SharePrefs.storePrefs("isLogin", false, "bool");
                SharePrefs.clearPrefs();
                  DatabaseHelper().deleteAllData(context);
                RouterClass.ReplaceScreen(context, "/startup");
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity, 
               
                child: Card(
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
                          backgroundImage: AssetImage('assets/user.png'), // Add a profile image
                        ),
                        SizedBox(height: 10),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TextColor
                          ),
                        ),
                        Text(branch,
                        style: TextStyle( color: TextColor),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  DashboardButton(
                    icon: Icons.computer_sharp,
                    label: 'Campus',
                    onPressed: () {
                      RouterClass.AddScreen(context, CoCampusScreen());
                    },
                  ),
                  DashboardButton(
                    icon: Icons.note,
                    label: 'Saved Campus',
                    onPressed: () {
                      RouterClass.AddScreen(context, CoSavedCampusScreen());
                    },
                  ),
                  DashboardButton(
                    icon: Icons.person,
                    label: 'Backup',
                    onPressed: () {
                      RouterClass.AddScreen(context, BackupScreen());
                    },
                  ),
                  DashboardButton(
                    icon: Icons.assessment,
                    label: 'Academics',
                    onPressed: () {
                      RouterClass.AddScreen(context, AcademicDetailsScreen());
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  DashboardButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: CardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16,color: TextColor),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherAvatar extends StatelessWidget {
  final String image;

  TeacherAvatar({required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(image),
      ),
    );
  }
}





