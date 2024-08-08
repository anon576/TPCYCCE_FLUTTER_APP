import 'package:flutter/material.dart';
import 'package:yccetpc/components/app_properties.dart';
import '../../components/custom_appbar.dart';
import '../../database/database.dart';
import '../../utils/material.dart';
class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<Map<String, dynamic>>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = DatabaseHelper().getNotifications();
  }

  void handleTapNotification(String screen,int id) {
  

  if (screen == '/campus') {
    // Navigate to the campus screen with optional data
    navigatorKey.currentState?.pushNamed('/campus');
  } else {
    // Navigate to the PYQScreen with campusId
    navigatorKey.currentState?.pushNamed('$screen', arguments: {'campusId': id});
  } 
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Notifications", context),
      backgroundColor: BackgroundColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications available.'));
          } else {
            final notifications = snapshot.data!.reversed.toList();
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return GestureDetector(
                  onTap: () {
                 handleTapNotification(notification['screen'],notification['screen_id']);
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: CardColor,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      leading: Icon(Icons.notifications, color: TextColor),
                      title: Row(
                        children: [
                          
                          Expanded(
                            child: Text(
                              notification['title'] ?? 'No Title',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: TextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                        
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              notification['body'] ?? 'No Body',
                              style: TextStyle(
                                fontSize: 14,
                                color: TextColor.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
          
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  

  void _onNotificationTap(Map<String, dynamic> notification) {
   
  }
}
