import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SinglePost extends StatefulWidget {
  SinglePost({super.key, required this.post, this.isCommenting = false});

  bool isCommenting;
  PostModel post;

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  final _focusNode = FocusNode();

  bool _isCommenting = false;
  setCommentingState() {
    setState(() {
      _isCommenting = !_isCommenting;
    });

    // Utilisation du post-frame callback pour accorder le focus une fois le TextField rendu.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isCommenting == true) {
      setCommentingState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // zone du nom du postant et la date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(),
                              const SizedBox(width: 10),
                              Text(widget.post.author,
                                  style:
                                      Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                          Text(
                            widget.post.date,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.grey),
                          )
                        ],
                      ),

                      // Zone du contenu du post
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          widget.post.content,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: double.infinity,
                            height: 400,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.grey),
                          )),

                      // zone des boutons d'action
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black45, width: 1.5)),
                        ),
                        child: Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  widget.post.liked = !widget.post.liked;
                                  widget.post.likes +=
                                      widget.post.liked ? 1 : -1;
                                });
                              },
                              icon: FaIcon(
                                widget.post.liked
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: widget.post.liked
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              label: Text("${widget.post.likes} likes"),
                              style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.black),
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.grey.shade200)),
                            ),
                            const SizedBox(width: 50),
                            TextButton.icon(
                              onPressed: () => setCommentingState(),
                              icon: const FaIcon(
                                FontAwesomeIcons.comment,
                              ),
                              label: Text(
                                  "${widget.post.comments.length} commentaires"),
                              style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.black),
                                  backgroundColor: !_isCommenting
                                      ? null
                                      : WidgetStateProperty.all(
                                          Colors.blue.shade100),
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.grey.shade200)),
                            )
                          ],
                        ),
                      ),

                      // zone de la liste des commentaires
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .75,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                customCommentTIle(context,
                                    author: "Postant",
                                    date: "01 Jan 2024 à 11:05",
                                    comment:
                                        "Je pense que tout est bon comme ça hein"),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
              )),

          // zone de texte pour faire un commentaire
          if (_isCommenting)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.surface),
                child: customTextField(
                    focusNode: _focusNode,
                    prefixIcon: const Icon(Icons.mode_comment_rounded,
                        color: Colors.grey),
                    suffix: IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.paperPlane,
                          color: Colors.green,
                          size: 20,
                        )),
                    label: "Commenter",
                    placeholder: "Ecrivez le contenu du post ici"),
              ),
            )
        ],
      ),
    );
  }

  Widget customCommentTIle(BuildContext context,
      {required String author, required String date, required String comment}) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(),
                    const SizedBox(width: 5),
                    Text(author)
                  ],
                ),
                Text(
                  date,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(comment),
            )
          ],
        ));
  }
}
