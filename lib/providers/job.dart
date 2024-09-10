import 'package:aesd_app/models/job_model.dart';
import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/services/web/job_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Job extends ChangeNotifier {
  final JobService _jobService = JobService();
  List<JobModel> _jobs = [];
  late Paginator _paginator;

  Future<Tuple2<List<JobModel>, Paginator>> all(
      {dynamic queryParameters}) async {
    _jobs = [];
    try {
      final data = await _jobService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _jobs.add(JobModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      ////print(e);
    }

    return Tuple2(_jobs, _paginator);
  }
}
