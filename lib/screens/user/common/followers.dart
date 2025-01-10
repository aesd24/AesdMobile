import 'package:aesd_app/components/field.dart';
import 'package:flutter/material.dart';

class FollowersPage extends StatefulWidget {
  FollowersPage({super.key, required this.community});

  bool community;

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {

  List<Map<String, dynamic>> servantList = List.generate(5, (value){
    return {
      "id" : value,
      "name": "Serviteur $value",
      "call": "appel $value"
    };
  });

  List<Map<String, dynamic>> faithFullist = List.generate(10, (value){
    return {
      "id" : value,
      "name": "Fidèle $value",
      "email": "email $value",
      "phone": "téléphone"
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.community ? "Ma communauté" : "Mes fidèles"
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // titre de la liste des serviteurs
              if(widget.community) Text(
                "Serviteurs",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if(widget.community) const Divider(),

              // liste des serviteurs
              if(widget.community) SizedBox(
                height: 170,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(servantList.length, (index){
                    var servant = servantList[index];
                    return _servantBox(
                      id: servant['id'],
                      name: servant['name'],
                      call: servant['call']
                    );
                  }),
                ),
              ),

              if(widget.community) const SizedBox(height: 50),

              // titre de la liste des fidèles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fidèles",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: customTextField(
                          label: "Rechercher",
                          suffix: PopupMenuButton(
                            icon: const Icon(Icons.filter_alt),
                            iconColor: Colors.grey,
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: "0", child: Text("option 0")),
                              PopupMenuItem(value: "1", child: Text("option 1")),
                              PopupMenuItem(value: "2", child: Text("option 2")),
                            ]
                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
              const Divider(),

              // liste des fidèles
              Column(
                children: List.generate(faithFullist.length, (value){
                  return Card(
                    color: Colors.green.shade100,
                    child: ListTile(
                      leading: const CircleAvatar(),
                      title: const Text("Nom du fidèle"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "courriel: adresse@email.dom",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.6)
                            )
                          ),
                          Text(
                            "Tel.: 0011223344",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.6)
                            )
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _servantBox({
    required int id,
    required String name,
    required String call,
  }){
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade300
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                name,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Text(
              call,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(.6)
              ),
            )
          ],
        ),
      ),
    );
  }
}