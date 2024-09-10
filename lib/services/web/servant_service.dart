import 'package:aesd_app/requests/servant_request.dart';

class ServantService {
  final ServantRequest _servantsRequest = ServantRequest();

  all({dynamic queryParameters}) async {
    try {
      final response = await _servantsRequest.all(queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      //
    }
  }

  one() async {
    try {
      final response = await _servantsRequest.one();
      if (response.statusCode == 200){
        return response.data;
      } else {
        throw Exception('Impossible de charger les informations de serviteurs');
      }
    } catch (e){
      //
    }
  }
}
