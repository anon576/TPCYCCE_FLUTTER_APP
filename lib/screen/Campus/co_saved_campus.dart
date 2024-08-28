import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';
import 'package:yccetpc/components/error_snackbar.dart';
import 'package:yccetpc/database/database.dart';

class CoSavedCampusScreen extends StatefulWidget {
  @override
  _CoSavedCampusScreenState createState() => _CoSavedCampusScreenState();
}

class _CoSavedCampusScreenState extends State<CoSavedCampusScreen> {
  List<Map<String, dynamic>> campuses = [];
  bool isLoading = true;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    fetchSavedCampuses();
  }

  Future<void> fetchSavedCampuses() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> campusList = await dbHelper.getCampuses();
      List<Map<String, dynamic>> updatedCampuses = [];

      for (var c in campusList) {
        Map<String, dynamic> campus = Map.from(c);
        List<Map<String, dynamic>> rounds =
            await dbHelper.getRounds(campus['CampusID']);
        campus['Rounds'] = rounds;
        updatedCampuses.add(campus);
      }

      setState(() {
        campuses = updatedCampuses.reversed.toList(); // Reverse the list
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }

  Future<void> markAttendance(String? attendanceId, int roundId) async {
    setState(() {
      isProcessing = true;
    });

    try {
      // Simulating attendance marking
     await DatabaseHelper().insertFailedAttendance(roundId, int.parse(attendanceId!));
      setState(() {
        isProcessing = false;
      });
      Fluttertoast.showToast(msg: 'Attendance marked successfully');
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
      title: Text(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Position the QR code within the frame to scan it. Make sure the code is well-lit and visible.',
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
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Close',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Co-Saved Campus", context),
      backgroundColor: BackgroundColor,
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: campuses.length,
                  itemBuilder: (context, index) {
                    final campus = campuses[index];
                    return Card(
                      color: CardColor,
                      elevation: 4,
                      margin: EdgeInsets.all(8),
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
                            SizedBox(height: 10),
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
                            SizedBox(height: 10),
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
