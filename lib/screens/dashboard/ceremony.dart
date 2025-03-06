import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/ceremony.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:aesd_app/screens/ceremonies/create.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CeremoniesManagement extends StatefulWidget {
  const CeremoniesManagement({super.key, required this.churchId});

  final int churchId;

  @override
  State<CeremoniesManagement> createState() => _CeremoniesManagementState();
}

class _CeremoniesManagementState extends State<CeremoniesManagement> {
  bool _isLoading = false;
  final List<CeremonyModel> _ceremonies = [];

  init() async {
    try{
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Ceremonies>(context, listen: false).all(
        churchId: widget.churchId
      );
    } catch(e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => closeForm(context),
          icon: FaIcon(FontAwesomeIcons.xmark, size: 20)
        ),
        title: Text('Ceremonies', style: TextStyle(fontSize: 20)),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              customButton(
                context: context,
                text: "Ajouter une cérémonie",
                trailing: FaIcon(FontAwesomeIcons.film, color: Colors.white),
                onPressed: () => pushForm(context, destination: CreateCeremony(churchId: widget.churchId))
              ),
              customTextField(
                prefixIcon: Icon(Icons.search),
                label: "Rechercher"
              ),
              SizedBox(height: 10),
              Expanded(
                child: _ceremonies.length != 0 ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(_ceremonies.length, (index){
                      var current = _ceremonies[index];
                      return current.card(context);
                    }),
                  )
                ) : Center(
                  child: Text(
                    "Aucune cérémonie disponible",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}