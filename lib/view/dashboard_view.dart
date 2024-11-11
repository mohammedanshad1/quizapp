// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quizapp/model/question_model.dart';
import 'package:quizapp/view/login_view.dart';
import 'package:quizapp/view/quiz_view.dart';
import 'package:quizapp/widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  final List<Question> questions;

  DashboardScreen({required this.questions});

  int get totalQuestions => questions.length;
  int get answeredQuestions =>
      questions.where((q) => q.selectedAnswer != null).length;
  int get skippedQuestions => questions.where((q) => q.isSkipped).length;
  int get correctAnswers => questions.where((q) {
        if (q.selectedAnswer == null) return false;
        return q.choices
            .firstWhere((c) => c.choiceText == q.selectedAnswer)
            .isCorrect;
      }).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Performance Summary Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiz Summary',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSummaryRow('Total Questions', totalQuestions),
                    _buildSummaryRow('Answered Questions', answeredQuestions),
                    _buildSummaryRow('Correct Answers', correctAnswers),
                    _buildSummaryRow('Skipped Questions', skippedQuestions),
                    _buildSummaryRow('Accuracy',
                        '${((correctAnswers / totalQuestions) * 100).toStringAsFixed(1)}%'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Performance Chart
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Chart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.green,
                              value: correctAnswers.toDouble(),
                              title: 'Correct',
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.red,
                              value: (answeredQuestions - correctAnswers)
                                  .toDouble(),
                              title: 'Incorrect',
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.grey,
                              value: skippedQuestions.toDouble(),
                              title: 'Skipped',
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Retry Quiz Button (Green)
                CustomButton(
                  buttonName: 'Retry Quiz',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => QuizScreen()),
                    );
                  },
                  buttonColor: Colors.green, // Green color for retry
                  height: 50, // Adjust height as needed
                  width: 150, // Adjust width as needed
                ),

                // Exit Button (Red)
                CustomButton(
                  buttonName: 'Exit',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  buttonColor: Colors.red, // Red color for exit
                  height: 50, // Adjust height as needed
                  width: 150, // Adjust width as needed
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
