import 'dart:io';

import 'package:dio/dio.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/functions/camera_functions.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TestImage extends StatefulWidget {
  const TestImage({super.key});

  @override
  State<TestImage> createState() => _TestImageState();
}

class _TestImageState extends State<TestImage> {

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test envoie d'image"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SizedBox(
                height: 300,
                width: 150,
                child: Image.file(image!, fit: BoxFit.cover,),
              )
            ),

            ElevatedButton(
              onPressed: () async {
                try{
                  image = await pickImage();
                  setState(() {});
                  var response = await Provider.of<Auth>(context, listen: false).sendFileTest(image!);

                  if (response.statusCode == 200){
                    showSnackBar(context: context, message: "Succès de l'opération", type: 'success');
                  } else {
                    showSnackBar(context: context, message: "Echec de l'opération", type: 'danger');
                  }
                  print(response.data);
                } on DioException catch(e) {
                  e.printError();
                }
                catch (e){
                  e.printError();
                }
              },
              child: const Text("Ajouter et envoyer une image"),
            )
          ],
        ),
      ),
    );
  }
}