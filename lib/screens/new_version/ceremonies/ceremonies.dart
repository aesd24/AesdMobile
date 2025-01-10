import 'package:dio/dio.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/models/ceremony.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:aesd_app/screens/new_version/ceremonies/ceremony_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});
  static const String routeName = "/ceremonies";

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List? ceremonies;

  @override
  void initState() {
    super.initState();
    getCeremonies();
  }

  getCeremonies() async {
    try {
      ceremonies = await Provider.of<Ceremonies>(context, listen: false).all();
      setState(() {});
    } on DioException catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "vérifiez votre connexion internet et rééssayez !",
          type: SnackBarType.warning);
    } catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "Une erreur s'est produite",
          type: SnackBarType.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des cérémonies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Builder(builder: (context) {
          if (ceremonies == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              children: List.generate(ceremonies!.length, (index) {
                return previewBox(item: ceremonies![index]);
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget previewBox({required CeremonyModel item}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CeremonyViewer(ceremony: item.toJson())));
      },
      child: Container(
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(blurRadius: 4, color: Colors.grey, offset: Offset(2, 2))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text("${item.date.day}/${item.date.month}/${item.date.year}")
              ],
            ),
            Text(
              "de: ${item.churchOwner.name}",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black45,
                  ),
            ),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black45,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
