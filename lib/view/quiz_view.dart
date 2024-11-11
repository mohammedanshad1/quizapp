// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:quizapp/model/question_model.dart';
import 'package:quizapp/view/dashboard_view.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> questions;
  int currentQuestionIndex = 0;
  int timeLeft = 30;
  late Timer timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    startTimer();
  }

  void loadQuestions() {
    // Simple arithmetic questions data
    questions = List.generate(50, (index) {
      int num1 = (index % 10) + 1; // Generate numbers from 1 to 10
      int num2 = ((index + 5) % 10) + 1;
      String questionText = 'Question ${index + 1}: What is $num1 + $num2?';
      int correctAnswer = num1 + num2;

      return Question(
        id: index + 1,
        questionText: questionText,
        choices: [
          Choice(
              id: 1,
              choiceText: 'Option A: ${correctAnswer}',
              isCorrect: true,
              questionId: index + 1),
          Choice(
              id: 2,
              choiceText: 'Option B: ${correctAnswer + 1}',
              isCorrect: false,
              questionId: index + 1),
          Choice(
              id: 3,
              choiceText: 'Option C: ${correctAnswer - 1}',
              isCorrect: false,
              questionId: index + 1),
          Choice(
              id: 4,
              choiceText: 'Option D: ${correctAnswer + 2}',
              isCorrect: false,
              questionId: index + 1),
        ],
      );
    });

    setState(() {
      isLoading = false;
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          skipQuestion();
        }
      });
    });
  }

  void submitAnswer() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        timeLeft = 30;
      });
    } else {
      showResults();
    }
  }

  void skipQuestion() {
    setState(() {
      questions[currentQuestionIndex].isSkipped = true;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        timeLeft = 30;
      } else {
        showResults();
      }
    });
  }

  void showResults() {
    timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(questions: questions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz (${currentQuestionIndex + 1}/50)'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Time: $timeLeft s',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 20),

            // Question
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      currentQuestion.questionText,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Choices
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.choices.length,
                itemBuilder: (context, index) {
                  Choice choice = currentQuestion.choices[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: RadioListTile<String>(
                      title: Text(choice.choiceText),
                      value: choice.choiceText,
                      groupValue: currentQuestion.selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          currentQuestion.selectedAnswer = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => skipQuestion(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: currentQuestion.selectedAnswer != null
                      ? submitAnswer
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
