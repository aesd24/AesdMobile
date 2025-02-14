import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/field.dart';
import 'package:flutter/material.dart';

class WithDrawingPage extends StatefulWidget {
  const WithDrawingPage({super.key});

  @override
  State<WithDrawingPage> createState() => _WithDrawingPageState();
}

class _WithDrawingPageState extends State<WithDrawingPage> {
  // controller
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retirer de l'argent"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Image.asset(
                "assets/icons/give.png",
                height: 100,
              ),
            ),
            customTextField(
                label: "Montant",
                placeholder: "Renseignez le montant à retirer",
                type: TextInputType.number,
                controller: amountController),
            customButton(context: context, text: "Valider", onPressed: () {})
          ],
        ),
      ),
    );
  }
}
