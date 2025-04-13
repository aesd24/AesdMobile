import 'dart:io';

import 'package:aesd_app/components/field.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/testimony/form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/snack_bar.dart';
import '../../providers/testimony.dart';

class TestimoniesList extends StatefulWidget {
  const TestimoniesList({super.key});

  @override
  State<TestimoniesList> createState() => _TestimoniesListState();
}

class _TestimoniesListState extends State<TestimoniesList> {
  bool isLoading = false;
  getTestimonies() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Testimony>(context, listen: false).getAll();
    } on HttpException {
      showSnackBar(
          context: context,
          message: "L'opération a échoué !",
          type: SnackBarType.danger
      );
    } catch(e) {
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
  void initState() {
    super.initState();
    getTestimonies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Les témoignages"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            if(isLoading) LinearProgressIndicator(
              minHeight: 2,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => pushForm(context, destination: TestimonyForm()),
                label: Text('Ajouter'),
                icon: FaIcon(FontAwesomeIcons.plus),
                iconAlignment: IconAlignment.end
              )
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: customTextField(
                      prefixIcon: const Icon(Icons.search),
                      label: "Rechercher",
                    ),
                  ),
                ],
              ),
            ),

            // liste des témoignages
            Expanded(
              child: RefreshIndicator(
                strokeWidth: 1.5,
                onRefresh: () async => await getTestimonies(),
                child: SingleChildScrollView(
                  child: Consumer<Testimony>(
                    builder: (context, provider, child) {
                      return Column(
                        children: List.generate(provider.testimonies.length, (index) {
                          var current = provider.testimonies[index];
                          return current.getWidget(context);
                        }),
                      );
                    }
                  )
                ),
              ),
            ),
            SizedBox(height: 25)
          ],
        ),
      )
    );
  }
}
