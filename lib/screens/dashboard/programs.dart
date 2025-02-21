import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/models/day_program.dart';
import 'package:aesd_app/screens/program/create.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProgramListPage extends StatefulWidget {
  const ProgramListPage({super.key, this.church});

  final ChurchModel? church;

  @override
  State<ProgramListPage> createState() => _ProgramListPageState();
}

class _ProgramListPageState extends State<ProgramListPage> {

  final List<DayProgramModel> _programs = List.generate(7, (index){
    return DayProgramModel.fromJson({
      'day': "Jour",
      'program': List.generate(3, (index) {
        return {
          'title': "Programme $index",
          'startTime': "${index + 10}:00:00",
          'endTime': "${index + 11}:00:00",
          'place': "Lien $index"
        };
      })
    });
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => closeForm(context),
          icon: FaIcon(FontAwesomeIcons.xmark, size: 20)
        ),
        title: Text("Programme", style: TextStyle(fontSize: 20))
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customButton(
                context: context,
                text: "Ajouter un programme",
                trailing: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 20
                ),
                onPressed: () => pushForm(
                  context,
                  destination: CreateProgramForm()
                )
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: List.generate(7, (index){
                    var current = _programs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: current.getWidget(context)
                    );
                  }),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}