import 'package:aesd_app/requests/forum_request.dart';

class ForumService {
  final ForumRequest _forumsRequest = ForumRequest();

  all({dynamic queryParameters}) async {
    try {
      final response =
          await _forumsRequest.all(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
//
}
  }
}
