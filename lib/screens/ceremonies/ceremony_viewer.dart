import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/components/snack_bar.dart';
import 'package:aesd_app/components/text_field.dart';
import 'package:aesd_app/providers/cinetpay.dart';
import 'package:aesd_app/screens/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CeremonyViewer extends StatefulWidget {
  CeremonyViewer({super.key, required this.ceremony});

  Map<String, dynamic> ceremony;

  @override
  State<CeremonyViewer> createState() => _CeremonyViewerState();
}

class _CeremonyViewerState extends State<CeremonyViewer> {
  final _formKey = GlobalKey<FormState>();
  // controlleur du montant du don
  final amountController = TextEditingController();

  bool isLoading = false;

  // video controllers
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  initializeVideo() {
    // initialisation du controller de vidéo
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.ceremony['video_url']));
    _videoPlayerController.initialize();

    // initialisation du conteneur de vidéo personnalisé
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );

    setState(() {});
  }

  makeDonation() async {
    try {
      setState(() {
        isLoading = true;
      });

      // vérifier que le formulaire a été validé
      if (!_formKey.currentState!.validate()) {
        return showSnackBar(
            context: context,
            message: "Entrez un montant correct !",
            type: SnackBarType.danger);
      }

      // initier un paiement cinetpay
      var response =
          await Provider.of<CinetPay>(context, listen: false).makePayment(
        context,
        amount: int.parse(amountController.text),
        description: "description",
        notifyUrl:
            "https://www.eglisesetserviteursdedieu.com/api/v1/notifyPayment",
        returnUrl: "https://www.eglisesetserviteursdedieu.com/api/v1/returnUrl",
      );

      // valeur de retour en fonction de la reponse reçu
      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        var json = jsonDecode(response.body);
        var data = json["data"];
        Uri paymentUrl = Uri.parse(data['payment_url']);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CustomWebView(
                  url: paymentUrl.toString(),
                  title: "Faire un paiement",
                )));
      } else {
        //print(response.statusCode);
      }
      //print(response.body);
    } catch (e) {
      e.printError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
          appBar: AppBar(title: Text(widget.ceremony['title'])),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.ceremony['date'].day}/${widget.ceremony['date'].month}/${widget.ceremony['date'].year}",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.ceremony['description'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black45),
                    ),

                    const SizedBox(height: 15),

                    // la vidéo
                    if (_chewieController != null)
                      SizedBox(
                        height: size.height * .3,
                        width: size.width,
                        child: Chewie(controller: _chewieController!),
                      ),

                    if (_chewieController == null)
                      const Center(
                          child: Text("La vidéo n'est pas disponible !")),

                    // partie des offrandes
                    Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: customTextField(
                                label: "Montant",
                                placeholder: "Combien voulez vous offrir ?",
                                type: TextInputType.number,
                                controller: amountController,
                                onChanged: (value) {
                                  if (int.tryParse(value) == null) {
                                    return showSnackBar(
                                        context: context,
                                        message:
                                            "Renseignez une valeur entière",
                                        type: SnackBarType.warning);
                                  }
                                },
                                validator: (value) {
                                  if (int.tryParse(value) == null) {
                                    return "Entrez une valeur entière uniquement !";
                                  }
                                  if (int.parse(value) % 5 != 0) {
                                    return "Le montant doit être multiple de 5 !";
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Fr",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),

                    customButton(
                        context: context,
                        text: "Faire une offrande",
                        onPressed: () async {
                          await makeDonation();
                        })
                  ]))),
    );
  }
}
