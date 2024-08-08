import 'package:flutter/material.dart';

import '../model/PYQ.dart';

Color BackgroundColor = const Color(0xff343a40);
Color TextColor = Colors.white;
Color HintColor = Color(0xff778da9);
Color CardColor = Color(0Xff495057);
Color ButtonColor = Colors.white;


const kTitleTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 25,
  letterSpacing: 1,
  fontWeight: FontWeight.w500,
);

const kSubtitleTextStyle = TextStyle(
  color: Colors.black38,
  fontSize: 16,
  letterSpacing: 1,
  fontWeight: FontWeight.w500,
);

List<String> skills = [
  'Accounting',
  'Agile Development',
  'Android Development',
  'Angular',
  'API Development',
  'Azure',
  'Big Data',
  'Blockchain',
  'C#',
  'C++',
  'Cloud Computing',
  'CSS',
  'Cybersecurity',
  'Data Analysis',
  'Data Science',
  'Database Management',
  'Django',
  'Docker',
  'ElasticSearch',
  'Embedded Systems',
  'Ethical Hacking',
  'Flutter',
  'Front End Development',
  'Game Development',
  'Git',
  'Google Cloud Platform',
  'HTML',
  'iOS Development',
  'Java',
  'JavaScript',
  'Jenkins',
  'Kotlin',
  'Laravel',
  'Machine Learning',
  'MATLAB',
  'MongoDB',
  'MySQL',
  'Node.js',
  'Objective-C',
  'Perl',
  'PHP',
  'PostgreSQL',
  'PowerShell',
  'Python',
  'React',
  'Ruby',
  'Rust',
  'Salesforce',
  'Scrum',
  'SQL',
  'Swift',
 'Terraform',
  'TypeScript',
  'UI/UX Design',
  'Unity',
  'Vue.js',
  'Web Development',
  'XML',
  'Xamarin'
];

List<PYQ> pyqs = [
  PYQ(
    question: "Write a program to reverse a string.",
    sampleInput: "Input: hello",
    sampleOutput: "Output: olleh",
    explanation: "The program should reverse the input string.",
    program: '''
    def reverse_string(s):
        return s[::-1]
    ''',
  ),
  PYQ(
    question: "Find the sum of all numbers in an array.",
    sampleInput: "Input: [1, 2, 3, 4]",
    sampleOutput: "Output: 10",
    explanation: "Sum all the elements in the array.",
    program: '''
  import 'package:flutter/material.dart';

import '../../components/app_properties.dart';
import '../../components/custom_appbar.dart';

class InterviewQuestionScreen extends StatefulWidget {
  const InterviewQuestionScreen({Key? key}) : super(key: key);

  @override
  _InterviewQuestionScreenState createState() => _InterviewQuestionScreenState();
}

class _InterviewQuestionScreenState extends State<InterviewQuestionScreen> {
  List<bool> showAnswers = []; // Track which answers are shown

  @override
  void initState() {
    super.initState();
    showAnswers = List<bool>.filled(interviewQuestions.length, false); // Initialize with false
  }

  void toggleAnswerVisibility(int index) {
    setState(() {
      showAnswers[index] = !showAnswers[index];
    });
  }

  @override
  Widget build(BuildContext context) {return Scaffold(appBar: CustomAppBar.screenAppbar("Interview Questions", contextbackgroundColor: BackgroundColor,
      body: ListView.builder(
        itemCount: interviewQuestions.length,
        itemBuilder: (context, index) {
          final question = interviewQuestions[index];
          return Card(
            color: CardColor,
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question: ",
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
                        Text("Answer: ", style: TextStyle(color: TextColor)),
                      ],
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


    ''',
  ),
];

// String apilink = "https://codestream.tech/api/tpcycce";

String apilink = "http://192.168.43.192:5000/api";
