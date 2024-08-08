// notification_details_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yccetpc/api/notification_api.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';
import 'package:yccetpc/components/shimmer_screen.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final int notificationId;

  const NotificationDetailsScreen({Key? key, required this.notificationId}) : super(key: key);

  @override
  _NotificationDetailsScreenState createState() => _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  late Future<Map<String, dynamic>> notificationFuture;

  @override
  void initState() {
    super.initState();
    notificationFuture = NotificationAPI.fetchNotificationById(widget.notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Notification Details", context),
      backgroundColor: BackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: notificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoading(itemCount: 5, height: 500, width: double.infinity);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data!['success']) {
              String title = snapshot.data!['data']['data']['title'];
              String shortLine = snapshot.data!['data']['data']['shortLine'];
              List<String> paragraphs = List<String>.from(snapshot.data!['data']['data']['paragraphs']);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: TextColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      shortLine,
                      style: TextStyle(
                        fontSize: 18,
                        color: TextColor,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: paragraphs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: CardColor,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                paragraphs[index],
                                style: TextStyle(color: TextColor),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text("Error: ${snapshot.data!['message']}"));
            }
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
