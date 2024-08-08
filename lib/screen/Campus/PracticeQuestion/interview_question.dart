import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yccetpc/api/pyq_api.dart';
import '../../../components/app_properties.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/shimmer_screen.dart';
import '../../../model/PYQ.dart';

class InterviewQuestionScreen extends StatefulWidget {
  final int campusId;

  const InterviewQuestionScreen({Key? key, required this.campusId}) : super(key: key);

  @override
  _InterviewQuestionScreenState createState() => _InterviewQuestionScreenState();
}

class _InterviewQuestionScreenState extends State<InterviewQuestionScreen> {
  late Future<Map<String, dynamic>> interviewQuestionsFuture;
  Timer? _viewTimer;
  List<bool> showAnswers = [];

  @override
  void initState() {
    super.initState();
    interviewQuestionsFuture = PYQAPI.fetchInterviewQuestions(widget.campusId);
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
     PYQAPI.markSeen('Interview', widget.campusId);
    } catch (e) {
      print('Error sending view status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.screenAppbar("Interview Questions", context),
      backgroundColor: BackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: interviewQuestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoading(itemCount: 5, height: 200, width: double.infinity);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data!['success']) {
              List<InterviewQuestion> questions = snapshot.data!['data'] as List<InterviewQuestion>;
if (showAnswers.length != questions.length) {
                showAnswers = List<bool>.filled(questions.length, false);
              }
              return ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Card(
                    color: CardColor,
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question: ${question.question}",
                            style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () => toggleAnswerVisibility(index),
                            child: Text(showAnswers[index] ? "Hide Answer" : "Show Answer"),
                          ),
                          if (showAnswers[index])
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8.0),
                                Text("Answer: ${question.answer}", style: TextStyle(color: TextColor)),
                              ],
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

  void toggleAnswerVisibility(int index) {
    setState(() {
      showAnswers[index] = !showAnswers[index];
    });
  }
}
