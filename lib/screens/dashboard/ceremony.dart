import 'dart:io';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/loader.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:aesd_app/screens/ceremonies/create.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CeremoniesManagement extends StatefulWidget {
  const CeremoniesManagement({super.key, required this.churchId});

  final int churchId;

  @override
  State<CeremoniesManagement> createState() => _CeremoniesManagementState();
}

class _CeremoniesManagementState extends State<CeremoniesManagement> {
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

  Future handleDeletion(element) async {
    try{
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Ceremonies>(context, listen: false).delete(
        element: element
      ).then((value) {
        showSnackBar(
          context: context,
          message: "Suppréssion éffectué",
          type: SnackBarType.success
        );
      });
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch (e) {
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
    return CustomFileLoader(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => closeForm(context),
            icon: FaIcon(FontAwesomeIcons.xmark, size: 20)
          ),
          centerTitle: true,
          title: Text('Ceremonies', style: TextStyle(fontSize: 20)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              customButton(
                context: context,
                text: "Ajouter une cérémonie",
                trailing: FaIcon(FontAwesomeIcons.film, color: Colors.white),
                onPressed: () => pushForm(context, destination: CeremonyForm(churchId: widget.churchId))
              ),
              customTextField(
                prefixIcon: Icon(Icons.search),
                label: "Rechercher"
              ),
              SizedBox(height: 10),
              Consumer<Ceremonies>(
                builder: (context, ceremonyProvider, child) {
                  return Expanded(
                  child: ceremonyProvider.ceremonies.isNotEmpty ? SingleChildScrollView(
                    child: Column(
                      children: List.generate(ceremonyProvider.ceremonies.length, (index){
                        var current = ceremonyProvider.ceremonies[index];
                        return current.card(context, onDelete: () => handleDeletion(current));
                      }),
                    )
                  ) : Center(
                    child: Text(
                      "Aucune cérémonie disponible",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}