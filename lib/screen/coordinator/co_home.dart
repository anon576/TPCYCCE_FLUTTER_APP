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
import '../Home/home.dart';
import '../Notification/notification.dart';




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
        centerTitle: true,
        title: Text(
          'YASHWANT',
          style: TextStyle(color: TextColor),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: BackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: TextColor,
            onPressed: () {
              RouterClass.AddScreen(context, NotificationsScreen());
            },
          ),
        ],
      ),
      backgroundColor: BackgroundColor,
      drawer: Drawer(
      backgroundColor: BackgroundColor, // Use your background color
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity, // Full width of the drawer
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey, // Updated background color
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(Icons.person, size: 50, color: Colors.blueGrey), // Profile icon
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: TextColor, // Use consistent text color
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildListTile(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {},
                ),
                _buildListTile(
                  icon: Icons.account_circle,
                  title: 'Backup',
                  onTap: () {
                    RouterClass.AddScreen(context, BackupScreen());
                  },
                ),
                SizedBox(height: 20), // Space before the logout button
              ],
            ),
          ),
          _buildListTile(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              SharePrefs.storePrefs("isLogin", false, "bool");
              SharePrefs.clearPrefs();
              DatabaseHelper().deleteAllData(context);
              RouterClass.ReplaceScreen(context, "/startup");
            },
            isLogout: true, // Pass a flag for styling logout differently
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

   Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: TextColor), // Use consistent icon color
      title: Text(
        title,
        style: TextStyle(color: TextColor), // Use consistent text color
      ),
      onTap: onTap,
      tileColor: isLogout ? const Color.fromARGB(255, 22, 20, 20) : Colors.transparent, // Special color for logout
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}







