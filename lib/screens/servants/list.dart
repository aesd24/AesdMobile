import 'dart:io';

import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/providers/servant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ServantList extends StatefulWidget {
  const ServantList({super.key});

  @override
  State<ServantList> createState() => _ServantListState();
}

class _ServantListState extends State<ServantList> {
  
  loadServants() async {
    try {
      await Provider.of<Servant>(context, listen: false).fetchServants();
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch(e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: "Une erreur inattendu s'est produite !",
          type: SnackBarType.danger
        );
      }
      e.printError();
    }
  }

  @override
  void initState() {
    super.initState();
    loadServants();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Servant>(
      builder: (context, servantProvider, child){
        if (servantProvider.servants.isEmpty) {
          return Center(
            child: Text("Aucun serviteur trouvé"),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: servantProvider.servants.length,
              itemBuilder: (context, index) {
                var current = servantProvider.servants[index];
                return current.card(context);
              }
            ),
          );
        }
      }
    );
  }
}