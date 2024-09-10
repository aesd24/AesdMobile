import 'package:dio/dio.dart';
import 'package:aesd_app/requests/cinetpay_request.dart';

class CinetPayService {
  final CinetpayRequest _cinetpayRequest = CinetpayRequest();

  verifyDonation({required String slug, required String transaction}) async {
    try {
      final response = await _cinetpayRequest.verifyDonation(
        slug: slug,
        transaction: transaction,
      );

      return response.data;
    } catch (e) {
      ////print(e);
    }
  }

  verifyStream({required String slug, required String transaction}) async {
    try {
      final response = await _cinetpayRequest.verifyStream(
        slug: slug,
        transaction: transaction,
      );

      return response.data;
    } catch (e) {
      ////print(e);
    }
  }

  verifyJetonBuy({required String transaction}) async {
    try {
      //print(transaction);

      final response = await _cinetpayRequest.verifyJetonBuy(
        transaction: transaction,
      );

      return response.data;
    } on DioException {
      //print(e.response?.data);
    }
  }
}
