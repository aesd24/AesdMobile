import 'package:aesd_app/models/course_deferred_model.dart';
import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/models/stream_model.dart';
import 'package:aesd_app/services/web/course_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Course extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  List<CourseDeferredModel> _deferredCourses = [];
  List<StreamModel> _streams = [];
  late Paginator _paginator;
  Paginator _streamsPaginator = Paginator();

  Future<Tuple2<List<CourseDeferredModel>, Paginator>> deferred(
      {dynamic queryParameters}) async {
    _deferredCourses = [];
    try {
      final data =
          await _courseService.deferred(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _deferredCourses.add(CourseDeferredModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      //
    }

    return Tuple2(_deferredCourses, _paginator);
  }

  Future<Tuple2<List<StreamModel>, Paginator>> streams(
      {dynamic queryParameters}) async {
    _streams = [];
    try {
      final data =
          await _courseService.streams(queryParameters: queryParameters);

      data['data'].forEach((date, items) {
        _streams.add(StreamModel.fromJson(date, items));
      });

      if (data['data'].length > 0) {
        _streamsPaginator = Paginator.fromJson(data);
      }
    } catch (e) {
      //////print(e);
    }

    return Tuple2(_streams, _streamsPaginator);
  }
}
