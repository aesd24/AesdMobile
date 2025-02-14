import 'package:aesd_app/components/field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customTextField(
                  label: "Recherche",
                  placeholder: "Entrez l'ID ou le montant de la transaction",
                  prefixIcon: const Icon(Icons.search),
                  suffix: PopupMenuButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.sort,
                        color: Colors.grey,
                        size: 20,
                      ),
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                              value: "date", child: Text("Trier par date")),
                          PopupMenuItem(
                              value: "amount",
                              child: Text("Trier par montant")),
                        ];
                      })),
              Column(
                children: List.generate(10, (index) {
                  return customTransactionRow(
                    label: "Transaction $index",
                    amount: (index + 1) * 1000,
                    date: DateTime(2000 + index),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTransactionRow({
    required String label,
    required int amount,
    required DateTime date,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height / 9,
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Theme.of(context).colorScheme.primaryContainer, width: 1)),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text("${date.day}/${date.month}/${date.year}",
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "$amount Fr",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
