import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:yccetpc/api/pyq_api.dart';
import '../../../components/app_properties.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/shimmer_screen.dart';
import '../../../model/PYQ.dart';

class PYQScreen extends StatefulWidget {
  final int campusId;

  const PYQScreen({Key? key, required this.campusId}) : super(key: key);

  @override
  _PYQScreenState createState() => _PYQScreenState();
}

class _PYQScreenState extends State<PYQScreen> {
  late Future<Map<String, dynamic>> pyqFuture;
  Timer? _viewTimer;

  @override
  void initState() {
    super.initState();
    pyqFuture = PYQAPI.fetchCodePYQ(widget.campusId);
    _startViewTimer();
  }

  @override
  void dispose() {
    _viewTimer?.cancel();
    super.dispose();
  }

  void _startViewTimer() {
    _viewTimer = Timer(Duration(minutes: 1), () {
      _sendViewStatus();
    });
  }

  Future<void> _sendViewStatus() async {
    try {
      print("time is working");
      PYQAPI.markSeen('Coding', widget.campusId);
    } catch (e) {
      print('Error sending view status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Code PYQ", context),
      backgroundColor: BackgroundColor,
     body: FutureBuilder<Map<String, dynamic>>(
  future: pyqFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return ShimmerLoading(itemCount: 5, height: 500, width: double.infinity);
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (snapshot.hasData) {
      if (snapshot.data!['success']) {
        // Directly cast to List<PYQ>
        List<PYQ> pyqs = snapshot.data!['data'] as List<PYQ>;
        return ListView.builder(
          itemCount: pyqs.length,
          itemBuilder: (context, index) {
            final pyq = pyqs[index];
            return Card(
              color: CardColor,
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question: ${pyq.question}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),
                    ),
                    const SizedBox(height: 8.0),
                    Text("Sample Input: ${pyq.sampleInput}", style: TextStyle(color: TextColor)),
                    const SizedBox(height: 8.0),
                    Text("Sample Output: ${pyq.sampleOutput}", style: TextStyle(color: TextColor)),
                    const SizedBox(height: 8.0),
                    Text("Explanation: ${pyq.explanation}", style: TextStyle(color: TextColor)),
                    const SizedBox(height: 8.0),
                    Text("Program:", style: TextStyle(color: TextColor)),
                    SyntaxView(
                      code: pyq.program,
                      syntax: Syntax.DART, // Change this based on the language
                      syntaxTheme: SyntaxTheme.dracula(),
                      withZoom: true,
                      withLinesCount: true,
                    ),
                  ],
                ),
              ),
            );
          },
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
