import 'package:aesd_app/functions/camera_functions.dart';
import 'package:flutter/material.dart';

void pickModeSelectionBottomSheet({
  required BuildContext context,
  bool photo = true,
  String? optionnalText,
  Color? optionnalTextColor,
  required void Function(dynamic) setter
}){
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context){
      return BottomSheet(
        onClosing: (){},
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height * .33,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if(optionnalText != null) Text(
                    "($optionnalText)",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: optionnalTextColor ?? Colors.red.shade300
                    ),
                  ),
                  Text(
                    "Prendre ${photo ? "la photo" : "la vidéo"} depuis la",
                    style: Theme.of(context).textTheme.titleMedium
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      photoModeCard(
                        context: context,
                        photo: photo,
                        onClick: () {
                          var file = photo ? pickImage() : pickVideo(camera: true);
                          setter(file);
                          Navigator.of(context).pop();
                        }
                      ),

                      photoModeCard(
                        context: context,
                        photo: photo,
                        camera: false,
                        onClick: () {
                          var file = photo ? pickImage(camera: false) : pickVideo();
                          setter(file);
                          Navigator.of(context).pop();
                        }
                      )
                    ]
                  ),
                ],
              ),
            ),
          );
        }
      );
    }
  );
}

Widget photoModeCard({
  required BuildContext context,
  required bool photo,
  bool camera = true,
  void Function()? onClick
}){
  return GestureDetector(
    onTap: onClick,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Colors.green)
          ),
          child: Icon(
            camera ?
            photo ? Icons.photo_camera : Icons.videocam :
            photo ? Icons.image : Icons.video_file,
            size: 70,
            color: Colors.green.shade800,
          )
        ),
        Text(
          camera ? "Caméra" : "Gallerie",
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    ),
  );
}