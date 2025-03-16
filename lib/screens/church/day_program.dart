import 'dart:io';

import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/models/day_program.dart';
import 'package:aesd_app/models/event.dart';
import 'package:aesd_app/providers/event.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Program extends StatefulWidget {
  const Program({super.key, required this.churchId});

  final int churchId;

  @override
  State<Program> createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  bool isLoading = false;
  var currentProgram = DayProgramModel.fromJson({
    'day': "Lundi",
    'program': List.generate(3, (index) {
      return {
        'title': "Programme $index",
        'startTime': "${index + 10}:00:00",
        'endTime': "${index + 11}:00:00",
        'place': "Lien $index"
      };
    })
  });

  /* var lastEvent = EventModel.fromJson({
    'id': 0,
    'titre':"Intitulé de l'évènement 1",
    'date_debut': DateTime.now(),
    'date_fin': DateTime.now(),
  }); */

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Event>(context, listen: false).getEvents(churchId: widget.churchId);
    } on HttpException catch (e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. Veuillez vérifier votre connexion internet.",
        type: SnackBarType.danger
      );
    } catch (e) {
      e.printError();
      showSnackBar(
        context: context,
        message: "Une erreur inattendue s'est produite !",
        type: SnackBarType.danger
      );
    } finally {
      setState(() {
        isLoading = false;
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
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Programme du jour",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.keyboard_arrow_right),
                    iconAlignment: IconAlignment.end,
                    label: const Text("Tout voir"))
              ],
            ),
            Consumer<Event>(
              builder: (context, eventProvider, child){
                EventModel? lastEvent;
                if (eventProvider.events.isNotEmpty) {
                  lastEvent = eventProvider.events.last;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: lastEvent != null ? 
                    lastEvent.getWidget(context) :
                    Text("Aucun événement pour le moment..."),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: currentProgram.getWidget(context),
            )
          ],
        ),
      );
    }
  }
}