import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';
import '../../api/attendance.dart';
import '../../database/database.dart';

class BackupScreen extends StatefulWidget {
  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  List<Map<String, dynamic>> failedAttendances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFailedAttendances();
  }

  Future<void> fetchFailedAttendances() async {
    final data = await DatabaseHelper().getFailedAttendances();
    setState(() {
      failedAttendances = data;
      isLoading = false;
    });
  }

  Future<void> retakeAttendance(int roundId, int attendanceId, int entryId) async {
    setState(() {
      isLoading = true;
    });

    final result = await AttendanceAPI.markAttendace(roundId, attendanceId);
    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      Fluttertoast.showToast(msg: 'Attendance marked successfully');
      await DatabaseHelper().deleteFailedAttendance(entryId);
      fetchFailedAttendances();
    } else {
      Fluttertoast.showToast(msg: 'Failed to mark attendance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Backup Attendance", context),
      backgroundColor: BackgroundColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : failedAttendances.isEmpty
              ? Center(child: Text("No failed attendances",style: TextStyle(color: TextColor),))
              : ListView.builder(
                  itemCount: failedAttendances.length,
                  itemBuilder: (context, index) {
                    final attendance = failedAttendances[index];
                    return Card(
                      color: CardColor,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text("Round ID: ${attendance['roundId']}",style: TextStyle(color: TextColor)),
                        subtitle: Text("Attendance ID: ${attendance['attendanceId']}",style: TextStyle(color: TextColor)),
                        trailing: IconButton(
                          icon: Icon(Icons.refresh),
                          color: TextColor,
                          onPressed: () {
                            retakeAttendance(
                              attendance['roundId'],
                              attendance['attendanceId'],
                              attendance['id'],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
