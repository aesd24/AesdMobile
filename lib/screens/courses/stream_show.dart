import 'dart:math';

import 'package:cinetpay/cinetpay.dart';
import 'package:aesd_app/models/stream_video_model.dart';
import 'package:aesd_app/screens/give_your_live_screen.dart';
import 'package:aesd_app/services/web/cinetpay_service.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StreamShow extends StatefulWidget {
  final StreamVideoModel video;

  const StreamShow({
    super.key,
    required this.video,
  });

  @override
  _StreamShowState createState() => _StreamShowState();
}

class _StreamShowState extends State<StreamShow> {
  //late YoutubePlayerController _controller;
  late TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();
  //final bool _loading = false;
  final CinetPayService _cinetpayService = CinetPayService();

  @override
  void initState() {
    super.initState();

    /*
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    */
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    //_controller.dispose();
    super.dispose();
  }

  _giveByCinetPay() async {
    if (_formKey.currentState!.validate()) {
      final amount = _amountController.text;

      final String transactionId = 'stream_${widget.video.id}_${Random().nextInt(100000000)}';

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
          'description': "Paiement de dîme à ${widget.video.ownerName}",
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
      await _cinetpayService.verifyStream(
        transaction: id,
        slug: widget.video.slug,
      );
    } catch (e) {
      ////print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  widget.video.dateTime,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                /*
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
                */
                /*
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        kPrimaryColor,
                      ),
                      elevation: MaterialStateProperty.all(6),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      'Payer la dîme',
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _giveByCinetPay(),
                  ),
                ),
                */
                const SizedBox(height: 10),
                Html(data: widget.video.description),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GiveYourLiveScreen(),
            ),
          );
        },
        backgroundColor: kSecondaryColor,
        child: const Icon(FontAwesomeIcons.church),
      ),
    );
  }
}
