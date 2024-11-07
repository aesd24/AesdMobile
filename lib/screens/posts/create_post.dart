import 'dart:io';
import 'package:aesd_app/components/bottom_sheets.dart';
import 'package:aesd_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key});

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Faire un post"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // zone d'affichage de l'image
                if (image != null)
                  Padding(
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
                              )),
                        ),
                        Positioned(
                          top: -16,
                          right: -14,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.surface),
                            child: IconButton(
                                onPressed: () => setState(() {
                                      image = null;
                                    }),
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.red),
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.white),
                                    overlayColor: WidgetStateProperty.all(
                                        Colors.white24)),
                                icon: const FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: 19,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),

                customMultilineField(
                    label: "Ecrivez le contenu du post",
                    maxLength: 1000,
                    maxLines: image != null ? 6 : 10,
                    controller: contentController),

                // zone pour les boutons
                Row(
                  mainAxisAlignment: image == null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (image == null)
                      IconButton(
                          onPressed: () => pickModeSelectionBottomSheet(
                              context: context, setter: setImage),
                          icon: FaIcon(
                            FontAwesomeIcons.solidImage,
                            size: 35,
                            color: Colors.blue.shade300,
                          )),
                    IconButton(
                      onPressed: () => print("Soumettre"),
                      icon: const FaIcon(
                        FontAwesomeIcons.paperPlane,
                        size: 35,
                      ),
                      style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                          overlayColor:
                              WidgetStateProperty.all(Colors.grey.shade300),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.green)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
