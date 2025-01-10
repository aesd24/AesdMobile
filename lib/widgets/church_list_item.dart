import 'package:aesd_app/models/church_model.dart';
import 'package:aesd_app/screens/church_show.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ChurchListItem extends StatelessWidget {
  ChurchModel church;

  ChurchListItem({super.key, 
    required this.church,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChurchShow(
              church: church,
            ),
          ),
        );
      },
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(4, 6), // Shadow position
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      church.name,
                      style: const TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        /*Image.asset(
                          "assets/calender.png",
                          height: 12,
                        ),*/
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          church.type!,
                          style: const TextStyle(
                            color: kSecondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        /*Image.asset(
                          "assets/location.png",
                          height: 12,
                        ),*/
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          church.mainServant != null
                              ? '${church.mainServant!.title.description}: ${church.mainServant!.user.name}'
                              : '---',
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
