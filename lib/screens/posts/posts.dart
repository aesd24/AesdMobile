import 'dart:io';

import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/models/post_model.dart';
import 'package:aesd_app/providers/post.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {

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
      await Provider.of<PostProvider>(context, listen: false).getPosts();
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
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child){
        if (postProvider.posts.isEmpty) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                ),
              ),
              Center(
                child: Text("Aucune publication pour le moment !"),
              ),
            ],
          );
        }
        return RefreshIndicator(
          onRefresh: () async => loadPosts(),
          child: ListView.builder(
            itemCount: postProvider.posts.length,
            itemBuilder: (context, index) => postProvider.posts[index].getWidget(
              context, onLike: onLike
            ),
          ),
        );
      }
    );
  }
}