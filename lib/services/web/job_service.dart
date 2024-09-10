import 'package:aesd_app/requests/job_request.dart';

class JobService {
  final JobRequest _jobsRequest = JobRequest();

  all({dynamic queryParameters}) async {
    try {
      final response = await _jobsRequest.all(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
//
}
  }
}
