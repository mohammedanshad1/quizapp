// lib/models/question.dart
class Question {
  final int id;
  final String questionText;
  final List<Choice> choices;
  String? selectedAnswer;
  bool isSkipped;

  Question({
    required this.id,
    required this.questionText,
    required this.choices,
    this.selectedAnswer,
    this.isSkipped = false,
  });

  // Add fromMap factory constructor
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int,
      questionText: map['question'] as String,
      choices: [], // Will be populated later with choices
      selectedAnswer: null,
      isSkipped: false,
    );
  }

  // Add toMap method for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': questionText,
    };
  }
}

class Choice {
  final int id;
  final int questionId;
  final String choiceText;
  final bool isCorrect;

  Choice({
    required this.id,
    required this.questionId,
    required this.choiceText,
    required this.isCorrect,
  });

  // Add fromMap factory constructor
  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      id: map['id'] as int,
      questionId: map['questionId'] as int,
      choiceText: map['choice'] as String,
      isCorrect: map['isCorrect'] == 1, // Convert integer to boolean
    );
  }

  // Add toMap method for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionId': questionId,
      'choice': choiceText,
      'isCorrect': isCorrect ? 1 : 0, // Convert boolean to integer
    };
  }
}