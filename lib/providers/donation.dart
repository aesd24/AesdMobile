import 'package:aesd_app/models/donation_model.dart';
import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/services/web/donation_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Donation extends ChangeNotifier {
  final DonationService _donationService = DonationService();
  List<DonationModel> _donation = [];
  late Paginator _paginator;

  Future<Tuple2<List<DonationModel>, Paginator>> all(
      {dynamic queryParameters}) async {
    _donation = [];
    try {
      final data = await _donationService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _donation.add(DonationModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      //////print(e);
    }

    return Tuple2(_donation, _paginator);
  }
}
