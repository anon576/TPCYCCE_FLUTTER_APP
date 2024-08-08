import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yccetpc/api/campus_api.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/error_snackbar.dart';
import 'package:yccetpc/components/route.dart';
import 'package:yccetpc/components/shimmer_screen.dart'; // Import your ShimmerLoading widget
import 'package:yccetpc/database/database.dart';
import 'package:yccetpc/screen/Campus/PracticeQuestion/code.dart';
import 'package:yccetpc/screen/Campus/PracticeQuestion/aptitude_lr.dart';
import '../../components/custom_appbar.dart';
import 'PracticeQuestion/interview_question.dart';

class CampusScreen extends StatefulWidget {
  @override
  _CampusScreenState createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  List<dynamic> campusData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCampusData();
  }

  Future<void> fetchCampusData() async {
    try {
      Map<dynamic, dynamic> result = await CampusAPI.fetchCampus();
      if (result['success']) {
        setState(() {
          campusData = result['campus'];
          isLoading = false;
        });
      } else {
        InputComponent.showWarningSnackBar(context, result['message']);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      InputComponent.showWarningSnackBar(context, "Something went wrong");
      setState(() {
        isLoading = false;
      });
    }
  }

  void saveToLocalDatabase(
      context,
      int campusId,
      String package,
      String campusName,
      String message,
      String date,
      String location,
      List<dynamic> rounds) async {
    await DatabaseHelper().insertCampus(
        context, campusId, campusName, message, package, date, location);
    for (var round in rounds) {
      await DatabaseHelper().insertRound(
          context,
          round['RoundID'],
          campusId,
          round['RoundName'],
          round['RoundDate'].toString(),
          round['Attendance']['AttendanceID']);
    }
    InputComponent.showWarningSnackBar(context, "Saved");
  }

  String attendance(String att, String date) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (att == "Present") {
      return att;
    } else if (att == "None") {
      if (date == today.toString()) {
        return "Absent";
      } else {
        return "None";
      }
    } else {
      return "None";
    }
  }

  void navigateToSection(String section,int campusID) {
    switch (section) {
      case "Coding":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PYQScreen(campusId: campusID), // Replace 1 with actual campus_id
          ),
        );

        break;
      case "Aptitude and LR":
        RouterClass.AddScreen(context, AptitudeLRScreen(campusId:campusID));
        break;
      case "Interview Questions":
        RouterClass.AddScreen(context, InterviewQuestionScreen(campusId: campusID));
        break;
    }
  }

  void _showQrCodeDialog(BuildContext context, String roundName, int attendanceId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 16,
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: CardColor,
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QR Code for $roundName',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: QrImageView(
                      data: attendanceId.toString(),
                      version: QrVersions.auto,
                      size: 200,
                      gapless: false,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Campus", context),
      backgroundColor: BackgroundColor,
      body: isLoading
          ? ShimmerLoading(itemCount: 5, height: 400, width: double.infinity)
          : ListView.builder(
              itemCount: campusData.length,
              itemBuilder: (context, index) {
                final campus = campusData[index];
                return Card(
                  color: CardColor,
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campus['CampusName'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: TextColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Message: ${campus['Message']}',
                          style: TextStyle(color: TextColor, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Date: ${campus['Date'].substring(0, 10)}',
                          style: TextStyle(color: TextColor, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Location: ${campus['Location']}',
                          style: TextStyle(color: TextColor, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Divider(color: Colors.grey[400]),
                        Text(
                          'Rounds:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TextColor,
                          ),
                        ),
                        ...campus['Rounds'].map<Widget>((round) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        round['RoundName'],
                                        style: TextStyle(
                                          color: TextColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Date: ${round['RoundDate'].substring(0, 10)}',
                                        style: TextStyle(color: TextColor, fontSize: 14),
                                      ),
                                      Text(
                                        'Attendance: ${attendance(round['Attendance']['AttendanceStatus'], round['RoundDate'].substring(0, 10))}',
                                        style: TextStyle(color: TextColor, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(Icons.qr_code, color: TextColor),
                                    onPressed: () {
                                      _showQrCodeDialog(
                                        context,
                                        round['RoundName'],
                                        round['Attendance']['AttendanceID'],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 10),
                        Divider(color: Colors.grey[400]),
                        Text(
                          'Campus Info:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TextColor,
                          ),
                        ),
                          SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ElevatedButton(
                                  onPressed: () => navigateToSection("Coding",campus['CampusID']),
                                  child: Text("Coding"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ButtonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                     padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ElevatedButton(
                                  onPressed: () => navigateToSection("Aptitude and LR",campus['CampusID']),
                                  child: Text("Aptitude and LR"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ButtonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: ElevatedButton(
                                  onPressed: () => navigateToSection("Interview Questions",campus['CampusID']),
                                  child: Text("Interview Questions"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ButtonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            saveToLocalDatabase(
                              context,
                              campus['CampusID'],
                              campus['package'],
                              campus['CampusName'],
                              campus['Message'],
                              campus['Date'],
                              campus['Location'],
                              campus['Rounds'],
                            );
                          },
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
