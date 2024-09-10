/*
import 'package:aesd_app/models/stream_video_model.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/requests/course_request.dart';
import 'package:aesd_app/screens/courses/stream_launched.dart';
import 'package:aesd_app/screens/courses/stream_list.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesFollowing extends StatefulWidget {
  const CoursesFollowing({super.key});

  @override
  State<CoursesFollowing> createState() => _CoursesFollowingState();
}

class _CoursesFollowingState extends State<CoursesFollowing> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final CourseRequest _courseRequest = CourseRequest();
  bool _loading = false;

  Future<void> _addStream(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      final response = await _courseRequest.create(
        title: _titleController.text,
        description: _descriptionController.text,
      );

      final data = response.data;

      final video = StreamVideoModel.fromJson(data['stream']);

      // _titleController.clear();
      // _descriptionController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamLaunched(video: video,),
        ),
      );
    } catch (e) {
      ////print(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Débuter un direct'),
          content: Form(
            child: SizedBox(
                width: 500,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: "Le titre du direct"
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "La description du direct."
                      ),
                    ),
                  ],
                ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Quitter', style: TextStyle(color: kDangerColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (_loading == false)
              TextButton(
                child: const Text('Ajouter', style: TextStyle(color: kPrimaryColor)),
                onPressed: () async => await _addStream(context),
              ),
            if (_loading)
              const CircularProgressIndicator(
                strokeWidth: 2,
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          Consumer<Auth>(
            builder: (context, auth, child) {
              if (auth.user.canManage) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: _showMyDialog,
                    child: const Text('Créer un direct'),
                  ),
                );
              } else {
                return Container();
              }
            }
          ),
        ],
      ),
      body: const StreamList(onlyFollower: true,),
    );
  }
}
*/