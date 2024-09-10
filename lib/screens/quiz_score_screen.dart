import 'package:aesd_app/models/participant_model.dart';
import 'package:aesd_app/models/quiz_model.dart';
import 'package:aesd_app/providers/participant.dart';
import 'package:aesd_app/widgets/quiz_score_item.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class QuizScoreScreen extends StatefulWidget {
  final QuizModel quiz;

  const QuizScoreScreen({
    super.key,
    required this.quiz,
  });

  @override
  _QuizScoreScreenState createState() => _QuizScoreScreenState();
}

class _QuizScoreScreenState extends State<QuizScoreScreen> {
  final PagingController<int, ParticipantModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage =
          await Provider.of<Participant>(context, listen: false).all(
        slug: widget.quiz.slug,
        queryParameters: {'page': pageKey},
      );

      final newNotices = newPage.item1;
      final paginator = newPage.item2;

      if (paginator.currentPage == paginator.lastPage) {
        _pagingController.appendLastPage(newNotices);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newNotices, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats du quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: PagedListView.separated(
          pagingController: _pagingController,
          separatorBuilder: (BuildContext context, index) =>
              const SizedBox(height: 0.2),
          builderDelegate: PagedChildBuilderDelegate<ParticipantModel>(
            itemBuilder: (BuildContext context, participant, index) =>
                QuizScoreItem(participant: participant, rang: (index + 1)),
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 300),
            /*firstPageProgressIndicatorBuilder: (BuildContext context) =>
                ShimmerListBloc(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2.0),
                    itemCount: 5,
                    containerHeight: 16.0 * 7.2,
                    containerWidth: 22.0),*/
            noItemsFoundIndicatorBuilder: (BuildContext context) =>
                const Text("Pas d'élement disponible pour le moment."),
            firstPageErrorIndicatorBuilder: (BuildContext context) => const Text(
                "Oups quelques choses s'est mal passé. Assurez vous d'être connecté."),
          ),
        ),
      ),
    );
  }
}
