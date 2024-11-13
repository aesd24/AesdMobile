import 'package:aesd_app/models/question_model.dart';
import 'package:aesd_app/models/quiz_model.dart';
import 'package:aesd_app/screens/quiz_play_screen.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:aesd_app/requests/quiz_request.dart';

class QuizShow extends StatefulWidget {
  final QuizModel quiz;

  const QuizShow({
    super.key,
    required this.quiz,
  });

  @override
  _QuizShowState createState() => _QuizShowState();
}

class _QuizShowState extends State<QuizShow> {
  bool _loading = false;
  bool _canPlay = true;
  final QuizRequest _quizRequest = QuizRequest();
  late List<QuestionModel> _questions = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    setState(() {
      _loading = true;
    });
    try {
      /* final response = await _quizRequest.show(widget.quiz.slug);

      //print(response.data);

      setState(() {
        _canPlay = response.data['canPlay'];
        _loading = false;
      }); */
    } catch (e) {
      ////print(e);
    } finally {}
  }

  _checkIfICanPlay() async {
    setState(() {
      _loading = true;
    });
    try {
      /* final response = await _quizRequest.canPlay(widget.quiz.slug);

      //print(response.data['questions']);

      setState(() {
        _canPlay = response.data['canPlay'];
        _loading = false;
        _questions = [];
        response.data['questions'].forEach(
            (question) => {_questions.add(QuestionModel.fromJson(question))});
      }); */
    } catch (e) {
      ////print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.quiz.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.quiz.description,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            _loading
                ? const Column(children: [
                    CircularProgressIndicator(),
                  ])
                : actionButton(),
          ],
        ),
      ),
    );
  }

  Widget actionButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          kPrimaryColor,
        ),
        elevation: WidgetStateProperty.all(6),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
      child: const Text(
        'Participer au jeux',
        style: TextStyle(
          fontFamily: 'PT-Sans',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        await _checkIfICanPlay();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPlayScreen(
              quiz: widget.quiz,
              questions: _questions,
              canPlay: _canPlay,
            ),
          ),
        );
      },
    );
  }
}
