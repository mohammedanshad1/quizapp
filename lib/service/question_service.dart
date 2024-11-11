


import 'package:quizapp/model/question_model.dart';
import 'package:quizapp/service/database_helper.dart';

class QuestionService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Question>> getQuestions() async {
    final db = await _databaseHelper.database;

    // Get all questions
    final List<Map<String, dynamic>> questionMaps = await db.query('Questions');
    List<Question> questions = [];

    for (var questionMap in questionMaps) {
      // Create Question object
      Question question = Question.fromMap(questionMap);

      // Get choices for this question
      final List<Map<String, dynamic>> choiceMaps = await db.query(
        'Choices',
        where: 'questionId = ?',
        whereArgs: [question.id],
      );

      // Create Choice objects and add them to the question
      List<Choice> choices = choiceMaps.map((m) => Choice.fromMap(m)).toList();
      
      // Create new Question with choices
      questions.add(Question(
        id: question.id,
        questionText: question.questionText,
        choices: choices,
      ));
    }

    return questions;
  }

  // Method to insert sample questions
  Future<void> insertSampleQuestions() async {
    final db = await _databaseHelper.database;
    
    // First, clear existing data
    await db.delete('Choices');
    await db.delete('Questions');
    
    // Insert 50 sample questions
    for (int i = 1; i <= 50; i++) {
      final questionId = await db.insert('Questions', {
        'question': 'Question $i: What is the capital of Country $i?',
        'answerChoicesId': i,
      });
      
      // Insert 4 choices for each question
      List<String> choices = [
        'City A for Question $i',
        'City B for Question $i',
        'City C for Question $i',
        'City D for Question $i'
      ];
      
      for (int j = 0; j < choices.length; j++) {
        await db.insert('Choices', {
          'questionId': questionId,
          'choice': choices[j],
          'isCorrect': j == 0 ? 1 : 0, // Make first choice correct for demo
        });
      }
    }
  }

  // Method to save student's answer
  Future<void> saveAnswer(int studentId, int questionId, int choiceId) async {
    final db = await _databaseHelper.database;
    await db.insert('StudentAnswers', {
      'studentId': studentId,
      'questionId': questionId,
      'choiceId': choiceId,
    });
  }
}
