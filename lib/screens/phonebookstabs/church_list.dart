import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/providers/church.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:aesd_app/widgets/church_list_item.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ChurchList extends StatefulWidget {
  final bool? onlyFollower;

  const ChurchList({super.key, this.onlyFollower});

  @override
  _ChurchListState createState() => _ChurchListState();
}

class _ChurchListState extends State<ChurchList> {
  final PagingController<int, ChurchModel> _pagingController =
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
      final newPage = await Provider.of<Church>(context, listen: false)
          .all(queryParameters: {'page': pageKey, 'onlyFollower': widget.onlyFollower ?? false});

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: PagedListView.separated(
          pagingController: _pagingController,
          separatorBuilder: (BuildContext context, index) =>
              const SizedBox(height: 0.2),
          builderDelegate: PagedChildBuilderDelegate<ChurchModel>(
            itemBuilder: (BuildContext context, church, index) =>
                ChurchListItem(church: church),
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
