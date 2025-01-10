import 'package:aesd_app/models/servant_model.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ServantCard extends StatelessWidget {
  final ServantModel servant;

  const ServantCard({super.key, required this.servant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(servant.user.photo!),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    servant.user.name,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    servant.title.description,
                    style: const TextStyle(color: kSecondaryColor, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
