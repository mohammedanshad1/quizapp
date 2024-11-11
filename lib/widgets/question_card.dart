import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final bool isActive;
  final Function(String) onAnswer;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.isActive,
    required this.onAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? Colors.white : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ...List.generate(
              4,
              (index) => RadioListTile<String>(
                value: question['choices'][index],
                groupValue: null,
                onChanged: isActive ? (value) => onAnswer(value!) : null,
                title: Text(question['choices'][index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}