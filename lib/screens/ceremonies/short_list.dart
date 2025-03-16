import 'dart:io';

import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/models/ceremony.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CeremonyShortList extends StatefulWidget {
  const CeremonyShortList({super.key, required this.churchId});

  final int churchId;

  @override
  State<CeremonyShortList> createState() => _CeremonyShortListState();
}

class _CeremonyShortListState extends State<CeremonyShortList> {
  bool _isLoading = false;

  init() async {
    try{
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Ceremonies>(context, listen: false).all(
        churchId: widget.churchId
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. Rééssayez...",
        type: SnackBarType.danger
      );
    } catch(e) {
      e.printError();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          height: 30, width: 30, child: CircularProgressIndicator()
        )
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            customTextField(
                label: "Rechercher", prefixIcon: const Icon(Icons.search)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {},
                label: const Text("Voir plus"),
                icon: const Icon(Icons.add),
                iconAlignment: IconAlignment.end,
              ),
            ),
            Consumer<Ceremonies>(
              builder: (context, ceremonyProvider, child) {
                List<CeremonyModel> eventList = ceremonyProvider.ceremonies
                  .reversed.toList().take(10).toList();
                return eventList.isNotEmpty ? Column(
                  children: List.generate(eventList.length, (index){
                    var current = eventList[index];
                    return current.card(context);
                  }),
                ) : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Aucune cérémonie disponible",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            )
          ],
        ),
      );
    }
  }
}