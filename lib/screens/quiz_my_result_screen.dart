import 'package:aesd_app/models/quiz_model.dart';
import 'package:flutter/material.dart';

class QuizMyResultScreen extends StatefulWidget {
  final QuizModel quiz;

  const QuizMyResultScreen({
    super.key,
    required this.quiz,
  });

  @override
  _QuizMyResultScreenState createState() => _QuizMyResultScreenState();
}

class _QuizMyResultScreenState extends State<QuizMyResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
