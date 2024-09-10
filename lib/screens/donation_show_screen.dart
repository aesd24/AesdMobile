
import 'package:cinetpay/cinetpay.dart';
import 'package:aesd_app/models/donation_model.dart';
import 'package:aesd_app/services/web/cinetpay_service.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:aesd_app/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class DonationShowScreen extends StatefulWidget {
  final DonationModel donation;

  const DonationShowScreen({super.key, required this.donation});

  @override
  _DonationShowScreenState createState() => _DonationShowScreenState();
}

class _DonationShowScreenState extends State<DonationShowScreen> {
  late final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CinetPayService _cinetpayService = CinetPayService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();

    super.dispose();
  }

  _giveByCinetPay() async {
    if (_formKey.currentState!.validate()) {
      final amount = _amountController.text;

      final String transactionId = 'donation_${widget.donation.id}_${const Uuid().v6()}';

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
          'description': "Donner à ${widget.donation.churchName}",
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
    try {
      await _cinetpayService.verifyDonation(
        transaction: id,
        slug: widget.donation.slug,
      );
    } catch (e) {
      ////print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Faites parler cotre Coeur.'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.donation.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.donation.date,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: (widget.donation.percent / 100),
                      semanticsLabel: 'Progression de la collecte',
                      minHeight: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.donation.description,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: kSecondaryColor,
                ),
                child: Column(
                  children: [
                    Text(
                      "Donner à ${widget.donation.churchName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Faites parler votre coeur en participant à la collecte. Montant minimum 500 FCFA.",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      hintText: 'Entrer le montant',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      prefixedIcon: const Icon(
                        Icons.attach_money,
                        color: Colors.black54,
                      ),
                      controller: _amountController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
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
                        child: const Text(
                          'Participer',
                          style: TextStyle(
                            fontFamily: 'PT-Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => _giveByCinetPay(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
