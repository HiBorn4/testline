class Quiz {
  final int id;
  final String title;
  final String description;
  final List<Question> questions;
  final double correctAnswerMarks;
  final double negativeMarks;
  final int duration;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.correctAnswerMarks,
    required this.negativeMarks,
    required this.duration,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
      correctAnswerMarks: double.parse(json['correct_answer_marks']),
      negativeMarks: double.parse(json['negative_marks']),
      duration: json['duration'],
    );
  }
}

class Question {
  final int id;
  final String description;
  final List<Option> options;

  Question({
    required this.id,
    required this.description,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      description: json['description'],
      options: (json['options'] as List)
          .map((option) => Option.fromJson(option))
          .toList(),
    );
  }
}

class Option {
  final int id;
  final String description;
  final bool isCorrect;

  Option({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      description: json['description'],
      isCorrect: json['is_correct'],
    );
  }
}
