import 'package:aesd_app/requests/dio_client.dart';

class ChurchRequest extends DioClient {
  Future all({required int page}) async {
    final client = await getApiClient();
    return client.get('user_church', queryParameters: {"page": page});
  }

  Future one(int id) async {
    final client = await getApiClient();
    return client.get("church/$id");
  }

  Future create(Object data) async {
    final client = await getApiClient(contentType: "Multipart/form-data");
    return await client.post("churches", data: data);
  }

  Future subscribe(int id) async {
    final client = await getApiClient();
    return client.post("churches_subscribe", queryParameters: {"id": id});
  }
}
