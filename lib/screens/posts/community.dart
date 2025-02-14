import 'package:aesd_app/models/post_model.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // liste des posts
  final List<PostModel> _posts = List.generate(3, (index) {
    return PostModel.fromJson({
      "id": index,
      "content": "Contenu du post",
      "author": "Auteur du post",
      "liked": false,
      "comments": [],
      "image_url": "image du post",
      "likes": 0
    });
  });

  stateNotifier() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List.generate(3, (value) {
                return _posts[value]
                    .getWidget(context, stateNotifier: stateNotifier);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
