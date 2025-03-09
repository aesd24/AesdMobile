import 'dart:io';

import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/models/post_model.dart';
import 'package:aesd_app/providers/post.dart';
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
  final ScrollController _scrollController = ScrollController();

  void scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !isLoading) {
      loadPosts();
    }
  }

  stateNotifier() {
    setState(() {});
  }

  Future onLike(PostModel post) async {
    try {
      await Provider.of<PostProvider>(context, listen: false).likePost(
        post.id
      ).then((value) {
        setState(() {
          post.likes = value['likeCount'];
          post.liked = value['like'];
        });
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
      showSnackBar(
        context: context,
        message: "Une erreur inattendu s'est produite !",
        type: SnackBarType.danger
      );
      e.printError();
    }
  }

  loadPosts() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1), () async {
        await Provider.of<PostProvider>(context, listen: false).getPosts();
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
      showSnackBar(
        context: context,
        message: "Une erreur inattendu s'est produite !",
        type: SnackBarType.danger
      );
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
    _scrollController.addListener(scrollListener);
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    List<PostModel> _posts = Provider.of<PostProvider>(context, listen: false).posts;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _posts.length,
              itemBuilder: (context, index) => _posts[index].getWidget(
                context, onLike: onLike
              ),
            ),
          ),
          if (isLoading) LinearProgressIndicator(
            borderRadius: BorderRadius.circular(20),
          )
        ],
      ),
    );
  }
}
