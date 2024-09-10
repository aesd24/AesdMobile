import 'package:aesd_app/requests/dio_client.dart';
import 'package:dio/dio.dart';

class CeremonyRequest extends DioClient {
  Future create(FormData formData) async {
    var client = await getApiClient(
      contentType: "multipart/form-data; boundary=${formData.boundary}"
    );
    return await client.post('/ceremonies', data: formData);
  }

  Future getAll() async {
    var client = await getApiClient();
    return await client.get('/ceremonies');
  }
}