import 'package:aesd_app/models/post_model.dart';
import 'package:aesd_app/requests/post_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final PostRequest _postService = PostRequest();

  Future create(Map<String, dynamic> data) async {
    final FormData formData = FormData.fromMap({
      'title': data['title'],
      'content': data['content'],
      'media': data['media'],
      'media_type': data['media_type']
    });
    _postService.create(data: formData);
  }

  Future<List<PostModel>> all() async {
    return await _postService.all();
  }
}
