import 'dart:io';
import 'package:aesd_app/components/bottom_sheets.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/providers/post.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key});

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // controller du contenue du post
  TextEditingController contentController = TextEditingController();

  // image associée au post
  File? image;
  setImage(dynamic newImage) async {
    if (newImage != null) {
      image = await newImage;
      setState(() {});
    }
  }

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar(
        context: context,
        message: "Remplissez correctement le formulaire",
        type: SnackBarType.danger
      );
      return;
    }

    await create();
  }

  create() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<PostProvider>(context, listen: false).create({
        "content": contentController.text,
        "image": image?.path
      }).then((value) {
        showSnackBar(
          context: context,
          message: "Création du post réussie",
          type: SnackBarType.success
        );
        closeForm(context);
      });
    } on DioException {
      showSnackBar(
        context: context,
        message: "Erreur réseau. Vérifiez votre connexion internet",
        type: SnackBarType.danger
      );
    } on HttpException catch(e) {
      showSnackBar(
        context: context,
        message: e.message,
        type: SnackBarType.danger
      );
    } catch(e) {
      e.printError();
      showSnackBar(
        context: context,
        message: "Une erreur inattendu est survenue",
        type: SnackBarType.danger
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => pickModeSelectionBottomSheet(
                context: context,
                setter: (value) => setImage(value)
              ),
              icon: const FaIcon(FontAwesomeIcons.camera),
            ),
            !isLoading ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: TextButton.icon(
                onPressed: () => handleSubmit(),
                label: Text("Poster"),
                iconAlignment: IconAlignment.end,
                icon: FaIcon(FontAwesomeIcons.paperPlane),
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.green)
                ),
              ),
            ) : Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.symmetric(horizontal: 7),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(100),
              ),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Colors.white
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // zone d'affichage de l'image
                  if (image != null) Padding(
                    padding: const EdgeInsets.all(5),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: FileImage(
                                image!,
                              ),
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                        Positioned(
                          top: -16,
                          right: -14,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).colorScheme.surface
                            ),
                            child: IconButton(
                              onPressed: () => setState(() {
                                image = null;
                              }),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.red),
                                foregroundColor: WidgetStateProperty.all(Colors.white),
                                overlayColor: WidgetStateProperty.all(Colors.white24)
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.xmark,
                                size: 19,
                              )),
                          ),
                        )
                      ],
                    ),
                  ),
            
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Que voulez vous partager aujourd'hui ?",
                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey
                        )
                      ),
                      controller: contentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
