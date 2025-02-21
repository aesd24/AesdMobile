import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/wallet/transactions.dart';
import 'package:aesd_app/screens/wallet/withdrawing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChurchWallet extends StatefulWidget {
  const ChurchWallet({super.key});

  @override
  State<ChurchWallet> createState() => _ChurchWalletState();
}

class _ChurchWalletState extends State<ChurchWallet> {
  bool _password = true;
  @override
  Widget build(BuildContext context) {
    var themeColors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => closeForm(context),
          icon: FaIcon(FontAwesomeIcons.xmark, size: 20)
        ),
        title: Text('Porte-feuille', style: TextStyle(fontSize: 20)),
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2.8,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.green),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _password ? "8.786" : "********",
                              style: GoogleFonts.orbitron(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 40),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _password = !_password;
                                  });
                                },
                                icon: FaIcon(
                                  _password
                                      ? FontAwesomeIcons.solidEye
                                      : FontAwesomeIcons.solidEyeSlash,
                                  color: Colors.white,
                                  size: 25,
                                ))
                          ],
                        ),
                        Text(
                          "XOF",
                          style: GoogleFonts.orbitron(
                              fontSize: 20, color: Colors.white60),
                        )
                      ],
                    ),
                  ),
                ),

                // boutons de transactions
                Positioned(
                  bottom: 30,
                  child: Center(
                    child: customTransactionButton(
                      title: "Retirer",
                      icon: Image.asset("assets/images/Recieve.png", scale: 2.5),
                      backColor: themeColors.primary,
                      onTap: () => pushForm(context,
                        destination: const WithDrawingPage()
                      )
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // liste des transactions
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Transactions",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith()),
                      const Spacer(),
                      TextButton(
                        onPressed: () => pushForm(context,
                            destination: const TransactionsPage()),
                        child: Text("Tout voir",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: themeColors.primary)),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                      children: List.generate(5, (index) {
                    return customTransactionRow(
                      label: "Transaction $index",
                      amount: (index + 1) * 1000,
                      date: DateTime(index + 2000, index, index),
                    );
                  }))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customTransactionButton(
      {required String title,
      required Widget icon,
      required Color backColor,
      void Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: backColor),
            child: Center(
              child: icon,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.white),
        )
      ],
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
      width: 365,
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