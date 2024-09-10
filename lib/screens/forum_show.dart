import 'package:aesd_app/models/comment_model.dart';
import 'package:aesd_app/models/forum_model.dart';
import 'package:aesd_app/requests/forum_request.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ForumShow extends StatefulWidget {
  final ForumModel forum;

  const ForumShow({
    super.key,
    required this.forum,
  });

  @override
  _ForumShowState createState() => _ForumShowState();
}

class _ForumShowState extends State<ForumShow> {
  final ForumRequest _forumRequest = ForumRequest();
  List<Comment> comments = [];
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    comments = widget.forum.comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires (${comments.length})'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () => {_showCommentBottomSheet()},
              child: const Icon(
                Icons.message_outlined,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                color: Theme.of(context).cardColor,
                elevation: 0.8,
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  margin: const EdgeInsets.only(right: 16, left: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 8.0),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              comments[index].userPhoto,
                                              scale: 1.0,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: comments[index].userName,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                comments[index].date,
                                style: TextStyle(
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          comments[index].comment,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Theme.of(context).disabledColor),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCommentBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Écrivez votre commentaire"),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    controller: _messageController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async {
                      try {
                        final response = await _forumRequest.addComment(
                          slug: widget.forum.slug,
                          message: _messageController.text,
                        );

                        _messageController.clear();

                        setState(() {
                          comments.insert(0, Comment.fromJson(response.data));
                        });
                      } catch (e) {
//
}
                    },
                    child: const Text(
                      'Envoyer',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
