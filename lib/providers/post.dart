import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/models/post_model.dart';
import 'package:aesd_app/services/web/post_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Post extends ChangeNotifier {
  final PostService _postService = PostService();
  List<PostModel> _posts = [];
  late Paginator _paginator;

  Future<Tuple2<List<PostModel>, Paginator>> all(
      {dynamic queryParameters}) async {
    _posts = [];
    try {
      final data = await _postService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _posts.add(PostModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      //
    }

    return Tuple2(_posts, _paginator);
  }
}
