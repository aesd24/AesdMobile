import 'package:aesd_app/requests/dio_client.dart';

class ChurchRequest extends DioClient {
  all({dynamic queryParameters}) async {
    final client = await getApiClient();

    return client.get('churchs', queryParameters: queryParameters);
  }

  one() async {
    final client = await getApiClient();
    return client.get("church");
  }

  Future create(Object data) async {
    final client = await getApiClient(contentType: "Multipart/form-data");
    return await client.post("churches", data: data);
  }
}
