import 'package:aesd_app/models/question_model.dart';
import 'package:aesd_app/models/quiz_model.dart';
//import 'package:aesd_app/requests/quiz_request.dart';
import 'package:aesd_app/screens/quiz_score_screen.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:aesd_app/widgets/app_overlay_loading.dart';
import 'package:aesd_app/widgets/question_options_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuizPlayScreen extends StatefulWidget {
  final QuizModel quiz;
  final List<QuestionModel> questions;
  final bool canPlay;

  const QuizPlayScreen({
    super.key,
    required this.quiz,
    required this.questions,
    required this.canPlay,
  });

  @override
  _QuizPlayScreenState createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _questionIndex = 0;
  final List<dynamic> _results = [];
  bool _loading = false;
  //final QuizRequest _quizRequest = QuizRequest();
  bool _canPlay = false;

  @override
  void initState() {
    super.initState();
    _canPlay = widget.canPlay;
  }

  _sendResult() async {
    setState(() {
      _loading = true;
    });
    try {
      /*
      final response = await _quizRequest.sendResult(
        slug: widget.quiz.slug,
        results: _results,
      ); */

      //print(response.data);
      setState(() {
        _canPlay = false;
      });
    } catch (e) {
      ////print(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _canPlay
        ? AppOverlayLoading(
            loading: _loading,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                // Fluttter show the back button automatically
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: const [
                  // FlatButton(onPressed: () => {}, child: Text("Passer")),
                ],
              ),
              body: Stack(children: [
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Container(
                          width: double.infinity,
                          height: 35,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: const Color(0xFF3F4768), width: 3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Stack(
                            children: [
                              // LayoutBuilder provide us the available space for the conatiner
                              // constraints.maxWidth needed for our animation
                              LayoutBuilder(
                                builder: (context, constraints) => Container(
                                  // from 0 to 1 it takes 60s
                                  width: (_questionIndex + 1) *
                                      MediaQuery.of(context).size.width /
                                      widget.questions.length,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF46A0AE),
                                        Color(0xFF00FFCB)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              /*Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("10 sec"),
                                SvgPicture.asset("assets/icons/clock.svg"),
                              ],
                            ),
                          ),
                        ),*/
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text.rich(
                          TextSpan(
                            text: "Question ${_questionIndex + 1}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: kSecondaryColor),
                            children: [
                              TextSpan(
                                text: "/ ${widget.questions.length}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: kSecondaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(thickness: 1.5),
                      const SizedBox(height: kDefaultPadding),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          padding: const EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.questions[_questionIndex].text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: const Color(0xFF101010),
                                    ),
                              ),
                              const SizedBox(height: kDefaultPadding / 2),
                              ...List.generate(
                                widget.questions[_questionIndex].options.length,
                                (index) => QuestionOptionsItem(
                                  index: index,
                                  text: widget.questions[_questionIndex]
                                      .options[index].option,
                                  isAnswered: false,
                                  press: () {
                                    setState(() {
                                      _results.add({
                                        'choice': widget
                                            .questions[_questionIndex]
                                            .options[index]
                                            .id,
                                        'question':
                                            widget.questions[_questionIndex].id,
                                      });
                                    });

                                    if (_questionIndex <
                                        (widget.questions.length - 1)) {
                                      setState(() {
                                        _questionIndex = _questionIndex + 1;
                                      });
                                    } else {
                                      _sendResult();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          )
        : Scaffold(
            appBar: AppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/icons/quiz.svg", width: 100),
                const SizedBox(
                  height: 80,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Vous avez déjà participé à ce quiz.',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
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
                    'Voir les résultats',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScoreScreen(
                          quiz: widget.quiz,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }
}
