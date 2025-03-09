import 'package:aesd_app/requests/dio_client.dart';

class PostRequest extends DioClient {
  Future all() async {
    final client = await getApiClient();
    return client.get('/posts');
  }

  Future create({required Object data}) async {
    final client = await getApiClient();
    return client.post('/posts', data: data);
  }

  Future likePost(int postId) async {
    final client = await getApiClient();
    return client.post('/like/$postId');
  }
}
