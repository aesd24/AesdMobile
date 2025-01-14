import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/models/servant_model.dart';
import 'package:aesd_app/requests/servant_request.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Servant extends ChangeNotifier {
  final ServantRequest _servantService = ServantRequest();
  List<ServantModel> _servants = [];
  late Paginator _paginator;

  // enregistrement des données de serviteur connecté
  late ServantModel servant = ServantModel();

  Future getServant() async {
    servant = ServantModel.fromJson(await _servantService.one());
    notifyListeners();
  }

  Future<Tuple2<List<ServantModel>, Paginator>> all({dynamic queryParameters}) async {
    _servants = [];
    try {
      final data = await _servantService.all(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _servants.add(ServantModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      ////print(e);
    }

    return Tuple2(_servants, _paginator);
  }
}
