import 'dart:io';
import 'package:aesd_app/components/bottom_sheets.dart';
import 'package:aesd_app/components/text_field.dart';
import 'package:flutter/material.dart';
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

    if(newImage != null) {
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  // zone d'affichage de l'image
                  if (image != null) Container(
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

                  customMultilineField(
                    label: "Ecrivez le contenu du post",
                    maxLength: 1000,
                    maxLines: image != null ? 4 : 6,
                    controller: contentController
                  ),

                  // zone pour les boutons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => image == null ? pickModeSelectionBottomSheet(
                            context: context,
                            setter: setImage
                          ) : {
                            setState(() {
                              image = null;
                            })
                          },
                          icon: Icon(
                            image == null ? Icons.photo : Icons.image_not_supported_rounded,
                            size: 40,
                            color: Colors.blue.shade300,
                          )
                        ),
                        ElevatedButton.icon(
                          onPressed: () => print("Soumettre"),
                          icon: const Icon(Icons.send_rounded),
                          iconAlignment: IconAlignment.end,
                          style: ButtonStyle(
                            elevation: WidgetStateProperty.all(0),
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primary
                            ),
                            overlayColor: WidgetStateProperty.all(Colors.white24),
                            foregroundColor: WidgetStateProperty.all(Colors.white)
                          ),
                          label: const Text("Envoyer")
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}