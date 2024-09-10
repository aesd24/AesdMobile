import 'package:aesd_app/models/singer_model.dart';
import 'package:aesd_app/providers/singer.dart';
import 'package:aesd_app/screens/singer_show.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:aesd_app/widgets/singer_list_item.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class SingerList extends StatefulWidget {
  const SingerList({super.key});

  @override
  _SingerListState createState() => _SingerListState();
}

class _SingerListState extends State<SingerList> {
  final PagingController<int, SingerModel> _pagingController =
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
      final newPage = await Provider.of<Singer>(context, listen: false)
          .all(queryParameters: {'page': pageKey});

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
          builderDelegate: PagedChildBuilderDelegate<SingerModel>(
            itemBuilder: (BuildContext context, singer, index) =>
                SingerListItem(
              singer: singer,
              onPress: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingerShow(
                      singer: singer,
                    ),
                  ),
                )
              },
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
