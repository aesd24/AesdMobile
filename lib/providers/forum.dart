import 'package:aesd_app/models/forum_model.dart';
import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/services/web/forum_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Forum extends ChangeNotifier {
  final ForumService _forumService = ForumService();
  List<ForumModel> _forums = [];
  late Paginator _paginator;

  Future<Tuple2<List<ForumModel>, Paginator>> all(
      {dynamic queryParameters}) async {
    _forums = [];
    try {
      final data = await _forumService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _forums.add(ForumModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      //////print(e);
    }

    return Tuple2(_forums, _paginator);
  }
}
