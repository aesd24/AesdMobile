import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/post_model.dart';
import 'package:aesd_app/screens/new_version/posts/create_post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            // bouton de création d'un nouveau post
            GestureDetector(
              onTap: () =>
                  pushForm(context, destination: const CreatePostForm()),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        const FaIcon(FontAwesomeIcons.globe,
                            size: 30, color: Colors.blue),
                        Text(
                          "Faire un post",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.blue),
                        )
                      ],
                    ),
                  )),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(3, (value) {
                    return _posts[value]
                        .getWidget(context, stateNotifier: stateNotifier);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
