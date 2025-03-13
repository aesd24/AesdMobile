import 'dart:io';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/providers/post.dart';
import 'package:aesd_app/screens/posts/posts.dart';
import 'package:aesd_app/screens/posts/servants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool isLoading = false;
  int _currentPage = 0;
  final _pageController = PageController();

  stateNotifier() {
    setState(() {});
  }

  loadPosts() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1), () async {
        if (context.mounted){
          await Provider.of<PostProvider>(context, listen: false).getPosts();
        }
      });
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch(e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: "Une erreur inattendu s'est produite !",
          type: SnackBarType.danger
        );
      }
      e.printError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

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
                Center(
                  child: Text('Chantre'),
                ),
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
