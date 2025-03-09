import 'dart:io';
import 'package:aesd_app/models/post_model.dart';
import 'package:aesd_app/requests/post_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final PostRequest _request = PostRequest();
  PostPaginator? _paginator;
  final List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  Future create(Map<String, dynamic> data) async {
    final FormData formData = FormData.fromMap({
      'contenu': data['content'],
      'image': data['image'],
    });
    var response = await _request.create(data: formData);
    print(response);
    if (response.statusCode != 201) {
      throw HttpException(response.data['message']);
    }
  }

  Future likePost(int id) async {
    final response = await _request.likePost(id);
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw HttpException(response.data['message']);
    }
  }

  Future getPosts() async {
    /* if (_paginator != null){
      if (_paginator!.currentPage >= _paginator!.totalPages) {
        return;
      }
    } else {
      // éffectuer la requête ici
    } */

    var response = await _request.all();
    print(response);
    _paginator = PostPaginator.fromJson(response.data);
    if (response.statusCode == 200) {
      _posts.clear();
      _posts.addAll(_paginator!.posts);
    } else {
      throw HttpException(response.data['message']);
    }
    _paginator!.currentPage += 1;
    notifyListeners();
    
  }
}
