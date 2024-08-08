import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:yccetpc/components/custom_appbar.dart';

class AcademicDetailsScreen extends StatefulWidget {
  @override
  _AcademicDetailsScreenState createState() => _AcademicDetailsScreenState();
}

class _AcademicDetailsScreenState extends State<AcademicDetailsScreen> {
  String sscYop = '';
  String sscPercentage = '';
  String hscYop = '';
  String hscPercentage = '';
  String sgpa1 = '';
  String sgpa2 = '';
  String sgpa3 = '';
  String sgpa4 = '';
  String sgpa5 = '';
  String sgpa6 = '';
  String sgpa7 = '';
  String avgSgpa = '';

  @override
  void initState() {
    super.initState();
    _loadAcademicInfo();
  }

  Future<void> _loadAcademicInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sscYop = sp.getString('ssc_yop') ?? '';
      sscPercentage = sp.getString('ssc_percentage') ?? '';
      hscYop = sp.getString('hsc_yop') ?? '';
      hscPercentage = sp.getString('hssc_percentage') ?? '';
      sgpa1 = sp.getString('sgpa1') ?? '';
      sgpa2 = sp.getString('sgpa2') ?? '';
      sgpa3 = sp.getString('sgpa3') ?? '';
      sgpa4 = sp.getString('sgpa4') ?? '';
      sgpa5 = sp.getString('sgpa5') ?? '';
      sgpa6 = sp.getString('sgpa6') ?? '';
      sgpa7 = sp.getString('sgpa7') ?? '';
      avgSgpa = sp.getString('avg_sgpa') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Academic Details", context),
      backgroundColor: BackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: CardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'SSC Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
,color:TextColor
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.school,color:TextColor),
                          SizedBox(width: 10),
                          Text(
                            "Year of Passing: $sscYop",
                            style: TextStyle(fontSize: 16,color:TextColor)
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.score,color:TextColor),
                          SizedBox(width: 10),
                          Text(
                            "Percentage: $sscPercentage%",
                            style: TextStyle(fontSize: 16,color:TextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: CardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'HSC Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,color:TextColor
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.school,color:TextColor,),
                          SizedBox(width: 10),
                          Text(
                            "Year of Passing: $hscYop",
                            style: TextStyle(fontSize: 16,color:TextColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.score,color:TextColor),
                          SizedBox(width: 10),
                          Text(
                            "Percentage: $hscPercentage%",
                            style: TextStyle(fontSize: 16,color:TextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: CardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'SGPA Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:TextColor
                        ),
                      ),
                      SizedBox(height: 10),
                      for (var sgpa in [
                        'SGPA1: $sgpa1',
                        'SGPA2: $sgpa2',
                        'SGPA3: $sgpa3',
                        'SGPA4: $sgpa4',
                        'SGPA5: $sgpa5',
                        'SGPA6: $sgpa6',
                        'SGPA7: $sgpa7',
                        'Avg SGPA: $avgSgpa'
                      ])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Icon(Icons.grade,color:TextColor),
                              SizedBox(width: 10),
                              Text(
                                sgpa,
                                style: TextStyle(fontSize: 16,color:TextColor),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
