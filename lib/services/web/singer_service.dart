import 'package:aesd_app/requests/singer_request.dart';

class SingerService {
  final SingerRequest _servantsRequest = SingerRequest();

  all({dynamic queryParameters}) async {
    try {
      final response =
          await _servantsRequest.all(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
//
}
  }
}
