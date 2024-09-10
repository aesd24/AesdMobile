import 'package:aesd_app/requests/post_request.dart';

class PostService {
  final PostRequest _postsRequest = PostRequest();

  all({dynamic queryParameters}) async {
    try {
      final response =
          await _postsRequest.all(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
//
}
  }
}
