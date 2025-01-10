import 'dart:io';
import 'package:aesd_app/components/bottom_sheets.dart';
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
          actions: [
            IconButton(
              onPressed: () => pickModeSelectionBottomSheet(
                context: context,
                setter: (value) => setImage(value)
              ),
              icon: const FaIcon(FontAwesomeIcons.camera),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: TextButton.icon(
                onPressed: (){},
                label: Text("Poster"),
                iconAlignment: IconAlignment.end,
                icon: FaIcon(FontAwesomeIcons.paperPlane),
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.green)
                ),
              ),
            )
          ],
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
                    maxLines: image == null ? 10 : 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
