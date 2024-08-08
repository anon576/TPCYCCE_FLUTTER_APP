class PYQ {
  final String question;
  final String sampleInput;
  final String sampleOutput;
  final String explanation;
  final String program;

  PYQ({
    required this.question,
    required this.sampleInput,
    required this.sampleOutput,
    required this.explanation,
    required this.program,
  });

  
}



class AptitudeQuestion {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;

  AptitudeQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });
}


class InterviewQuestion {
  final String question;
  final String answer;

  InterviewQuestion({
    required this.question,
    required this.answer,
  });
}
