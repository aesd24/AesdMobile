import 'package:aesd_app/models/forum_model.dart';
import 'package:aesd_app/screens/forum_show.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ForumListItem extends StatelessWidget {
  final ForumModel forum;
  final VoidCallback onPress;

  const ForumListItem({
    super.key,
    required this.forum,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForumShow(
              forum: forum,
            ),
          ),
        )
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3.0,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              forum.title,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      forum.date,
                      style: const TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      ' | ${forum.commentCount} commentaires',
                      style: const TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                forum.categories[0].name,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              forum.body,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
