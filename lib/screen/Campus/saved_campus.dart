import 'package:flutter/material.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';
import 'package:yccetpc/components/error_snackbar.dart';
import 'package:yccetpc/database/database.dart';

class SavedCampusScreen extends StatefulWidget {
  @override
  _SavedCampusScreenState createState() => _SavedCampusScreenState();
}

class _SavedCampusScreenState extends State<SavedCampusScreen> {
  List<Map<String, dynamic>> campuses = [];
  bool isLoading = true;

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
        campuses = updatedCampuses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      InputComponent.showWarningSnackBar(context, "Something went wrong here");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Saved Campus", context),
      backgroundColor: BackgroundColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: campuses.length,
              itemBuilder: (context, index) {
                final campus = campuses[campuses.length - index - 1];
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
                                Icons.qr_code,
                                color: TextColor,
                              ),
                              onPressed: () {
                                InputComponent.showQrCodeDialog(
                                        context,
                                        round['RoundName'],
                                        round['AttendanceID'],
                                      );
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
    );
  }
}
