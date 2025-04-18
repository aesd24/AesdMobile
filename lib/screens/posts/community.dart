import 'package:aesd_app/screens/posts/posts.dart';
import 'package:aesd_app/screens/servants/list.dart';
import 'package:aesd_app/screens/singer/list.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          elevation: 0,
          bottom: TabBar(
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
              borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.all(10),
            tabs: [
              customIcon(assetName: 'posts'),
              customIcon(assetName: 'costume'),
              customIcon(assetName: 'micro'),
            ]
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: TabBarView(
            children: [
              PostList(),
              ServantList(),
              SingerList()
            ],
          ),
        ),
      ),
    );
  }

  Widget customTab({
    required int index,
    required String text,
    required Color color,
    required String assetName
  }) {
    bool selected = _currentPage == index;
    return InkWell(
      overlayColor: WidgetStatePropertyAll(color.withAlpha(50)),
      onTap: () {
        _pageController.animateToPage(
          index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut
        );
        setState(() {
          _currentPage = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: selected ? BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ) : null,
        child: Row(
          children: [
            customIcon(assetName: assetName),
            SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                color: color
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget customIcon({required String assetName}) {
    return Image.asset("assets/icons/$assetName.png", width: 35, height: 35);
  }
}
