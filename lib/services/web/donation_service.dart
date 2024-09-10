import 'package:aesd_app/requests/donation_request.dart';

class DonationService {
  final DonationRequest _donationRequest = DonationRequest();

  all({dynamic queryParameters}) async {
    try {
      final response =
          await _donationRequest.all(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
      ////print(e);
    }
  }
}
