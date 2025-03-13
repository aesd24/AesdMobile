import 'package:aesd_app/requests/dio_client.dart';

class PostRequest extends DioClient {
  Future all() async {
    final client = await getApiClient();
    return client.get('/posts');
  }

  Future detail(int id) async {
    final client = await getApiClient();
    return client.get('/posts/$id');
  }

  Future create({required Object data}) async {
    final client = await getApiClient();
    return client.post('/posts', data: data);
  }

  Future likePost(int postId) async {
    final client = await getApiClient();
    return client.post('/like/$postId');
  }

  Future makeComment(int postId, String comment) async {
    final client = await getApiClient();
    return client.post('/comments/$postId', data: {
      'comment': comment
    });
  }
}
