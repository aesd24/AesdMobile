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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    customTab(
                      index: 0,
                      text: "Posts",
                      assetName: 'posts',
                      color: Colors.blue
                    ),

                    customTab(
                      index: 1,
                      text: "Serviteurs",
                      assetName: 'costume',
                      color: Colors.purple
                    ),

                    customTab(
                      index: 2,
                      text: "Chantre",
                      assetName: 'micro',
                      color: Colors.pink
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              children: [
                PostList(),
                ServantList(),
                SingerList()
              ],
            ),
          ),
        ],
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
            Image.asset("assets/icons/$assetName.png", width: 35, height: 35),
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
}
