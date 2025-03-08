import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/providers/event.dart';
import 'package:aesd_app/screens/events/create_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class ChurchEvents extends StatefulWidget {
  const ChurchEvents({super.key, required this.churchId});

  final int churchId;

  @override
  State<ChurchEvents> createState() => _ChurchEventsState();
}

class _ChurchEventsState extends State<ChurchEvents> {
  bool _isLoading = false;

  init() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Event>(context, listen: false).getEvents(
        churchId: widget.churchId
      );
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. Vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: "Une erreur inattendu est survenue",
        type: SnackBarType.danger
      );
      e.printError();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future deleteEvent(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Event>(context, listen: false).delete(
        id
      ).then((value) {
        showSnackBar(
          context: context,
          message: "Elément supprimé avec succès !",
          type: SnackBarType.success
        );
      });
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. Vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch(e) {
      showSnackBar(
        context: context,
        message: "Une erreur inattendu est survenue",
        type: SnackBarType.danger
      );
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
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => closeForm(context),
            icon: FaIcon(FontAwesomeIcons.xmark, size: 20)
          ),
          title: Text('Evènements', style: TextStyle(fontSize: 20)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              customButton(
                context: context,
                text: "Ajouter un évènement",
                trailing: FaIcon(FontAwesomeIcons.film, color: Colors.white),
                onPressed: () => pushForm(context, destination: EventForm(churchId: widget.churchId))
              ),
              customTextField(
                prefixIcon: Icon(Icons.search),
                label: "Rechercher"
              ),

              Consumer<Event>(
                builder: (context, eventProvider, child) {
                  if (eventProvider.events.isEmpty){
                    return Expanded(
                      child: Center(
                        child: Text(
                          "Aucun évènement disponible",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: eventProvider.events.length,
                        itemBuilder: (context, index) {
                          var current = eventProvider.events[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: current.getWidget(
                              context,
                              adminMode: true,
                              onDelete: deleteEvent
                            ),
                          );
                        }
                      )
                    );
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}