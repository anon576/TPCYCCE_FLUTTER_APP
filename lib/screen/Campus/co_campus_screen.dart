import 'package:flutter/material.dart';
import 'package:yccetpc/api/attendance.dart';
import 'package:yccetpc/api/campus_api.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';
import 'package:yccetpc/components/error_snackbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../database/database.dart';

class CoCampusScreen extends StatefulWidget {
  @override
  _CoCampusScreenState createState() => _CoCampusScreenState();
}

class _CoCampusScreenState extends State<CoCampusScreen> {
  List<dynamic> campusData = [];
  bool isLoading = true;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    fetchCampusData();
  }

  Future<void> fetchCampusData() async {
    try {
      Map<dynamic, dynamic> result = await CampusAPI.cofetchCampus();
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

  Future<void> markAttendance(String? attendanceId, int roundId) async {
    setState(() {
      isProcessing = true;
    });

    try {
      Map<String, dynamic> result =
          await AttendanceAPI.markAttendace(roundId, int.parse(attendanceId!));
      setState(() {
        isProcessing = false;
      });

      if (result['success']) {
        Fluttertoast.showToast(msg: 'Attendance marked successfully');
      } else {
        InputComponent.showWarningSnackBar(context, result['message']);
      }
    } catch (error) {
      setState(() {
        isProcessing = false;
      });
      InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }

  void _showQRScanner(BuildContext context, int roundID) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Scan QR Code',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black87,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Please point the camera at the QR code to scan it. The QR code should be clearly visible within the frame.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: QRView(
              key: GlobalKey(debugLabel: 'QR'),
              onQRViewCreated: (QRViewController controller) {
                controller.scannedDataStream.listen((scanData) {
                  controller.dispose();
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: 'Scanned successfully: ${scanData.code} : ${roundID}');
                  print('Scanned Data: ${scanData.code}');
                  markAttendance(scanData.code, roundID);
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

   void saveToLocalDatabase(context,int CampusId, String package, String CampusName, String Message, String Date, String Location, List<dynamic> Rounds) async {
    await DatabaseHelper().insertCampus(context,CampusId, CampusName, Message, package, Date, Location);
    for (var round in Rounds) {
      await DatabaseHelper().insertRound(context,round['RoundID'], CampusId, round['RoundName'], round['RoundDate'].toString(), 2208);
    }
    InputComponent.showWarningSnackBar(context, "Saved to local database");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Campus", context),
      backgroundColor: BackgroundColor,
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: campusData.length,
                  itemBuilder: (context, index) {
                    final campus = campusData[index];
                    return Card(
                      color: CardColor,
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              campus['CampusName'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: TextColor),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Message: ${campus['Message']}',
                              style: TextStyle(color: TextColor),
                            ),
                            Text(
                              'Date: ${campus['Date'].substring(0, 10)}',
                              style: TextStyle(color: TextColor),
                            ),
                            Text(
                              'Location: ${campus['Location']}',
                              style: TextStyle(color: TextColor),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Rounds:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: TextColor),
                            ),
                            ...campus['Rounds'].map<Widget>((round) {
                              return ListTile(
                                title: Text(
                                  round['RoundName'],
                                  style: TextStyle(color: TextColor),
                                ),
                                subtitle: Text(
                                  'Date: ${round['RoundDate'].substring(0, 10)}',
                                  style: TextStyle(color: TextColor),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.qr_code_scanner,
                                    color: TextColor,
                                  ),
                                  onPressed: () {
                                    _showQRScanner(context, round['RoundID']);
                                  },
                                ),
                              );
                            }).toList(),
                             const SizedBox(height: 10),
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
                          child: const Text('Save',style: TextStyle(color: Colors.black),),
                        ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
