import 'package:aesd_app/requests/dio_client.dart';
import 'package:dio/dio.dart';

class ChurchRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('/churchs', queryParameters: queryParameters);
  }

  one () async {
    final client = await getApiClient();
    return client.get("church/");
  }

  Future create(FormData data) async {
    try {
      final client = await getApiClient(
        contentType: "multipart/form-data; boundary=${data.boundary}",
      );

      return await client.post("/churchs", data: data);
    } on DioException catch(e){
      return e.response;
    }
  }
}
