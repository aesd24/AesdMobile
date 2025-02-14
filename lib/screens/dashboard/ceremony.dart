import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/ceremonies/create.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CeremoniesManagement extends StatefulWidget {
  const CeremoniesManagement({super.key});

  @override
  State<CeremoniesManagement> createState() => _CeremoniesManagementState();
}

class _CeremoniesManagementState extends State<CeremoniesManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => closeForm(context),
          icon: FaIcon(FontAwesomeIcons.xmark)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            customTextField(
              prefixIcon: Icon(Icons.search),
              label: "Rechercher"
            ),
            customButton(
              context: context,
              text: "Ajouter une cérémonie",
              trailing: FaIcon(FontAwesomeIcons.film, color: Colors.white),
              onPressed: () => pushForm(context, destination: CreateCeremony())
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(5, (index){
                    return InkWell(
                      overlayColor: WidgetStateProperty.all(Colors.orange.shade50),
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(7)
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Titre de la cérémonie",
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Colors.white
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  Text(
                                    "jj/mm/AAAA",
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white70
                                    ),
                                  )
                                ]
                              ),
                            ),
                      
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description de la cérémonie",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.grey.shade700
                                    )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: (){},
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Colors.amber.shade100),
                                            iconColor: WidgetStateProperty.all(Colors.amber)
                                          ),
                                          icon: FaIcon(FontAwesomeIcons.pen, size: 20)
                                        ),
                                        IconButton(
                                          onPressed: (){},
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Colors.red.shade100),
                                            iconColor: WidgetStateProperty.all(Colors.red)
                                          ),
                                          icon: FaIcon(FontAwesomeIcons.trash, size: 20)
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}