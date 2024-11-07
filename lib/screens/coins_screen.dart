
import 'package:aesd_app/providers/user.dart';
import 'package:cinetpay/cinetpay.dart';
//import 'package:aesd_app/models/user_model.dart';
//import 'package:aesd_app/providers/auth.dart';
//import 'package:aesd_app/services/web/cinetpay_service.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:aesd_app/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CoinsScreen extends StatefulWidget {
  const CoinsScreen({super.key,});

  @override
  State<CoinsScreen> createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {
  final TextEditingController _coinTotalController = TextEditingController();
  //final CinetPayService _cinetpayService = CinetPayService();
  
  num amount = 0;
  @override
  void dispose() {
    _coinTotalController.dispose();

    super.dispose();
  }

  _buyByCinetPay() async {
    if (amount >= 100) {
      final String transactionId = const Uuid().v6();

      await Get.to(CinetPayCheckout(
        title: 'Paiement ESD',
        configData: const <String, dynamic>{
          'apikey': '14638022065a1ece323e8456.99379118',
          'site_id': '617170',
          'mode': 'prod'
        },
        paymentData: <String, dynamic>{
          'transaction_id': transactionId,
          'amount': amount, // plan.spacePricing.price,
          'currency': 'XOF',
          'channels': 'MOBILE_MONEY',
          'description': "Achat de jeton",
        },
        waitResponse: (response) {
          if (response['status'] == 'ACCEPTED') {
            _verifyCinetPayPaiment(transactionId);
          }
        },
        onError: (data) {
          if (mounted) {}
        },
      ));
    }
  }

  _verifyCinetPayPaiment(id) async {
    /* try {
      final data = await _cinetpayService.verifyJetonBuy(
        transaction: id,
      );

      //Provider.of<Auth>(context, listen: false).setUserData(UserModel.fromJson(data['user']));
    } catch (e) {
      //print('erreur');
      // 1ee859ee-2ba2-6100-8bcf-19094b3b6289
      ////print(e);
    } finally {} */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achat de jetons"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Consumer<User>(
                builder: (context, cons, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total jetons', style: TextStyle(color: Colors.blueAccent)),
                          Text(
                              cons.user.totalCoins.toString(),
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0)
                          )
                        ],
                      ),
                      Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.money, color: Colors.white, size: 30.0),
                              )
                          )
                      )
                    ]
                  );
                }),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child:
              CustomTextField(
                hintText: 'Entrer le nombre de jetons',
                obscureText: false,
                keyboardType: TextInputType.number,
                prefixedIcon: const Icon(
                  Icons.attach_money,
                  color: Colors.black54,
                ),
                controller: _coinTotalController,
                onChanged: (value) {
                  setState(() {
                    amount = int.parse(value) * 10;
                  });
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "";
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            amount >= 100 ?  ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  kPrimaryColor,
                ),
                elevation: WidgetStateProperty.all(6),
                shape: WidgetStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              child: Text(
                'Acheter pour $amount FCFA',
                style: const TextStyle(
                  fontFamily: 'PT-Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _buyByCinetPay(),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}