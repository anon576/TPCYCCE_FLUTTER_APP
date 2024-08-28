import 'package:flutter/material.dart';
import 'app_properties.dart';
import 'share_prefs.dart';

class CustomAppBar {
  // Static method for creating a screen-specific app bar
  static PreferredSizeWidget screenAppbar(String title, BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: BackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: TextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.chevron_left,
          color: TextColor,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: TextButton(
            onPressed: () async {
              // Get the role from shared preferences
              String? role = await SharePrefs.readPrefs("role", "string");

              // Navigate based on the role
              String route = role == "student" ? '/home' : '/coscreen';

              Navigator.pushNamedAndRemoveUntil(
                context,
                route, // Navigate to the route based on the role
                (Route<dynamic> route) => false, // Remove all routes
              );
            },
            child: Text(
              'TPC',
              style: TextStyle(
                color: TextColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
