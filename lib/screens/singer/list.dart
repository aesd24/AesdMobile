import 'dart:io';

import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/providers/singer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SingerList extends StatefulWidget {
  const SingerList({super.key});

  @override
  State<SingerList> createState() => _SingerListState();
}

class _SingerListState extends State<SingerList> {
  loadSingers() async {
    try {
      await Provider.of<Singer>(context, listen: false).fetchSingers();
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
    loadSingers();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<Singer>(
      builder: (context, singerProvider, child){
        if (singerProvider.singers.isEmpty) {
          return Column(
            children: [
              SizedBox(
                height: 1.5,
                child: LinearProgressIndicator(),
              ),
              Expanded(
                child: Center(
                  child: Text("Aucun(e) chantre trouvé(e) !"),
                ),
              ),
            ],
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: singerProvider.singers.length,
              itemBuilder: (context, index) {
                var current = singerProvider.singers[index];
                return current.card(context);
              }
            ),
          );
        }
      }
    );
  }
}