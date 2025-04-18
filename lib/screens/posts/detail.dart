import 'dart:io';

import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/formatteurs.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/post_model.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/providers/post.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class SinglePost extends StatefulWidget {
  const SinglePost({super.key, required this.post, this.isCommenting = false});

  final bool isCommenting;
  final PostModel post;

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _focusNode = FocusNode();
  bool showAllText = false;

  // controller
  final _commentController = TextEditingController();

  bool _isCreatingComment = false;
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

  loadPost() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<PostProvider>(context, listen: false).postDetail(
        widget.post.id
      );
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } catch(e) {
      showSnackBar(
        context: context,
        message: "Une erreur inattendu s'est produite !",
        type: SnackBarType.danger
      );
      e.printError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future like(PostModel post) async {
    try {
      await Provider.of<PostProvider>(context, listen: false).likePost(
        post.id
      ).then((value) {
        setState(() {
          post.likes = value['likeCount'];
          post.liked = value['like'];
        });
      });
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch(e) {
      showSnackBar(
        context: context,
        message: "Une erreur inattendu s'est produite !",
        type: SnackBarType.danger
      );
      e.printError();
    }
  }

  makeComment() async {
    if (_formKey.currentState!.validate()){
      try {
        setState(() {
          _isCreatingComment = true;
        });
        await Future.delayed(Duration(seconds: 1), () async {
          await Provider.of<PostProvider>(context, listen: false).makeComment(
          widget.post.id, _commentController.text
        ).then((value) async {
          await Provider.of<PostProvider>(context, listen: false).postDetail(
            widget.post.id
          ).then((value) {
                      setState(() {
            _isCommenting = false;
          });
          });
          showSnackBar(
            context: context,
            message: "Commentaire ajouté avec succès !",
            type: SnackBarType.success
          );
        });
        });
      } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch(e) {
      showSnackBar(
        context: context,
        message: "Une erreur inattendu s'est produite !",
        type: SnackBarType.danger
      );
      e.printError();
    } finally {
      setState(() {
        _isCreatingComment = false;
      });
    }
    }
  }

  @override
  void initState() {
    super.initState();
    loadPost();
    if (widget.isCommenting == true) {
      setCommentingState();
    }
    setState(() {
      showAllText = widget.post.content.length <= 300;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                formatDate(widget.post.date),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.grey),
              ),
            )
          ],
        ),
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
                        children: [
                          CircleAvatar(
                            backgroundImage: widget.post.author.photo != null ?
                            NetworkImage(
                              widget.post.author.photo!
                            ) : null,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.post.author.name,
                            style: Theme.of(context).textTheme.titleMedium
                          )
                        ],
                      ),
      
                      // Zone du contenu du post
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: widget.post.content.length > 300 ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: showAllText ? widget.post.content :
                                '${widget.post.content.substring(0, 300)}... ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: !showAllText ? 'Voir plus' : 'Voir moins',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline
                                ),
                                recognizer: TapGestureRecognizer()
                                ..onTap = (){
                                  setState(() {
                                    showAllText = !showAllText;
                                  });
                                }
                              )
                            ]
                          )
                        ) : Text(
                          widget.post.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ),

                      // image (s'il y en a une)
                      if (widget.post.image != null) Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.zero,
                                child: Stack(
                                  children: [
                                    PhotoView(
                                      imageProvider: NetworkImage(widget.post.image!),
                                      backgroundDecoration: BoxDecoration(
                                        color: Colors.black.withAlpha(150)
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      right: 20,
                                      child: GestureDetector(
                                        onTap: () => closeForm(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(50),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: FaIcon(
                                            FontAwesomeIcons.xmark,
                                            color: Colors.white
                                          )
                                        ),
                                      )
                                    )
                                  ],
                                )
                              );
                            },
                          ),
                          child: Image.network(
                            widget.post.image!,
                            fit: BoxFit.fill,
                          )
                        )
                      ),
      
                      // zone des boutons d'action
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black45, width: 1.5)
                          ),
                        ),
                        child: Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => like(widget.post),
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
                                  "${widget.post.comments} commentaires"),
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(Colors.black),
                                iconColor: WidgetStateProperty.all(Colors.black),
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
                      Consumer<PostProvider>(
                        builder: (context, postProvider, child){
                          return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                              children: List.generate(
                                postProvider.comments.length, (index){
                                  var element = postProvider.comments[index];
                                  return customCommentTile(
                                    context,
                                    author: element.owner,
                                    date: formatDate(element.date),
                                    comment: element.content
                                  );
                                }
                              ),
                            )
                      );
                        }
                      )
                    ]
                  ),
              )
            ),
      
            // zone de texte pour faire un commentaire
            if (_isCommenting)
              Form(
                key: _formKey,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface
                    ),
                    child: customTextField(
                        focusNode: _focusNode,
                        prefixIcon: const Icon(Icons.mode_comment_rounded,
                            color: Colors.grey),
                        suffix: !_isCreatingComment ? IconButton(
                            onPressed: () => makeComment(),
                            icon: const FaIcon(
                              FontAwesomeIcons.paperPlane,
                              color: Colors.green,
                              size: 20,
                            )
                        ) : Padding(
                          padding: EdgeInsets.all(15),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        ),
                      label: "Commenter",
                      placeholder: "Ecrivez le contenu du post ici",
                      controller: _commentController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un commentaire';
                        }
                        return null;
                      }
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget customCommentTile(BuildContext context,
      {required UserModel author, required String date, required String comment}) {
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
                    CircleAvatar(
                      backgroundImage: author.photo != null ? NetworkImage(
                        author.photo!
                      ) : null,
                    ),
                    SizedBox(width: 5),
                    Text(author.name)
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
