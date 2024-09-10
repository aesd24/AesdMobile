import 'package:flutter/material.dart';

class WalletForm extends StatefulWidget {
  const WalletForm({super.key});

  @override
  State<WalletForm> createState() => _WalletFormState();
}

class _WalletFormState extends State<WalletForm> {
  bool _password = true;
  @override
  Widget build(BuildContext context) {
    var themeColors = Theme.of(context).colorScheme;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: themeColors.onPrimary,),
        ),
        backgroundColor: Colors.green,
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
                  decoration: const BoxDecoration(
                    color: Colors.green
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Text(
                              "Solde AESD",
                              style: TextStyle(
                                color: themeColors.onPrimary.withOpacity(.7),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _password
                                ? const Text(
                                    "XOF 8.786,55",
                                    style: TextStyle(
                                        fontSize: 32, color: Color(0xffFFFFFF)),
                                  )
                                : const Text(
                                    '  ********',
                                    style: TextStyle(
                                        fontSize: 32, color: Color(0xffFFFFFF)),
                                  ),
                            const SizedBox(width: 10),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _password = !_password;
                                  });
                                },
                                child: _password
                                    ? const Icon(Icons.visibility,
                                        size: 24, color: Color(0xffFFFFFF))
                                    : const Icon(Icons.visibility_off,
                                        size: 24, color: Color(0xffFFFFFF))),
                            // Expand
                            // Expanded(child: AppConstants.Width(90)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // boutons de transactions
                Positioned(
                  bottom: 30,
                  left: 35,
                  right: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTransactionButton(
                        title: "Envoyer",
                        icon: Image.asset("assets/images/logout.png", scale: 2.5),
                        backColor: themeColors.primary
                      ),

                      customTransactionButton(
                        title: "Retirer",
                        icon: Image.asset("assets/images/Recieve.png", scale: 2.5),
                        backColor: themeColors.primary
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height:20),

            // liste des transactions
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Transactions",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(

                        )
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const Transaction_all(),));
                        },
                        child: Text(
                          "See all",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: themeColors.primary
                          )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height:20),

                  Column(
                    children: List.generate(5, (index){
                      return customTransactionRow(
                        label: "Transaction $index",
                        amount: (index + 1) * 1000,
                        date: DateTime(index + 2000, index, index),
                        height: height
                      );
                    })
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customTransactionButton({
    required String title,
    required Widget icon,
    required Color backColor
  }){
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const Top_up(),));
          },
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: backColor
            ),
            child: Center(
              child: icon,
            ),
          ),
        ),
        const SizedBox(height:5),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Colors.white
          ),
        )
      ],
    );
  }

  Widget customTransactionRow({
    required String label,
    required int amount,
    required DateTime date,
    required double height
  }){
    return Container(
      height: height / 9,
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 365,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.primaryContainer, width: 1)
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(),
                const SizedBox(width: 15,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: Theme.of(context).textTheme.labelSmall
                    ),
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