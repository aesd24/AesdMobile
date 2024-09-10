import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/models/singer_model.dart';
import 'package:aesd_app/services/web/singer_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Singer extends ChangeNotifier {
  final SingerService _servantService = SingerService();
  List<SingerModel> _singers = [];
  late Paginator _paginator;

  Future<Tuple2<List<SingerModel>, Paginator>> all(
      {dynamic queryParameters}) async {
    _singers = [];
    try {
      final data = await _servantService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _singers.add(SingerModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      ////print(e);
    }

    return Tuple2(_singers, _paginator);
  }
}
