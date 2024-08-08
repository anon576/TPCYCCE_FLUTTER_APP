import 'package:flutter/material.dart';
import 'app_properties.dart';
import 'share_prefs.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserNameFromPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            backgroundColor: BackgroundColor,
            automaticallyImplyLeading: false,
            title: CircularProgressIndicator(), // Placeholder while loading
            elevation: 0,
            centerTitle: false,
          );
        } else if (snapshot.hasError) {
          return AppBar(
            automaticallyImplyLeading: false,
            title: Text('Error loading user name'), // Placeholder for error
            backgroundColor: BackgroundColor,
            elevation: 0,
            centerTitle: false,
          );
        } else {
          final userName = snapshot.data!;
          return AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 4000,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                  // RouterClass.AddScreen(context, ProfileScreen());
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/user.png'),
                    radius: 20,
                  ),
                ),

                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'ExBooks',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 25),
                ),
                // SizedBox(width: 1), // Adjust spacing between the icon and text
              ],
            ),
            backgroundColor: BackgroundColor,
            elevation: 0,
            centerTitle: false,
          );
        }
      },
    );
  }

  Future<String> _getUserNameFromPrefs() async {
    return await SharePrefs.readPrefs("name", "string") ?? 'Guest';
  }

  static PreferredSizeWidget? screenAppbar(String title, context) {
    return AppBar(
      backgroundColor:BackgroundColor,
      title: Text(
        '$title',
        style: TextStyle(
          color: TextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon:  Icon(
          Icons.chevron_left,
          color: TextColor,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: TextButton(onPressed: (){
Navigator.pushNamedAndRemoveUntil(
              context,
              '/home', // Main screen route
              (Route<dynamic> route) => false, // Remove all routes
            );
          }, child: Text(
            'TPC',
            style: TextStyle(
              color: TextColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),)
        
     ) ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}