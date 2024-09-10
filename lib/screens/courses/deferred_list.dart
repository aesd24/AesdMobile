import 'package:aesd_app/models/course_deferred_model.dart';
import 'package:aesd_app/providers/course.dart';
import 'package:aesd_app/screens/courses/deferred_show.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class CourseDeferredList extends StatefulWidget {
  const CourseDeferredList({super.key});

  @override
  _CourseDeferredListState createState() => _CourseDeferredListState();
}

class _CourseDeferredListState extends State<CourseDeferredList> {
  final PagingController<int, CourseDeferredModel> _pagingController =
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
      final newPage = await Provider.of<Course>(context, listen: false)
          .deferred(queryParameters: {'page': pageKey});

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
    return RefreshIndicator(
      backgroundColor: scaffold,
      color: kPrimaryColor,
      displacement: 10.0,
      strokeWidth: 1.0,
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: PagedListView.separated(
          pagingController: _pagingController,
          separatorBuilder: (BuildContext context, index) =>
              const SizedBox(height: 0.2),
          builderDelegate: PagedChildBuilderDelegate<CourseDeferredModel>(
            itemBuilder: (BuildContext context, course, index) =>
                GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiferredShow(
                      course: course,
                    ),
                  ),
                )
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      course.shortBody,
                      style: const TextStyle(
                        color: Colors.black26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
