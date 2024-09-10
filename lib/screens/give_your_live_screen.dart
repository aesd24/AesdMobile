//import 'package:aesd_app/requests/give_your_life_request.dart';
//import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
/* import 'package:fluttertoast/fluttertoast.dart'; */

class GiveYourLiveScreen extends StatefulWidget {
  const GiveYourLiveScreen({super.key});

  @override
  _GiveYourLiveScreenState createState() => _GiveYourLiveScreenState();
}

class _GiveYourLiveScreenState extends State<GiveYourLiveScreen> {
  late TextEditingController _nameController,
      _phoneController,
      _addressController,
      _subjectController;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  //final GiveYourLifeRequest _giveYourLifeRequest = GiveYourLifeRequest();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _subjectController = TextEditingController();
  }

  send() async {
    if (_formKey.currentState!.validate()) {
      _loading = true;
      try {
        try {

          /* Fluttertoast.showToast(
            msg:
                "Demande envoyé avec succès. Nous vous contacterons très bientôt..",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: kPrimaryColor,
            textColor: kWhiteColor,
            fontSize: 13.0,
          ); */

          _nameController.clear();
          _phoneController.clear();
          _addressController.clear();
          _subjectController.clear();
        } catch (e) {
          ////print(e);
        }
      } finally {
        _loading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                "DONNER SA VIE AU SEIGNEUR JESUS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'Votre nom et prénom',
                ),
                controller: _nameController,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'Votre numéro de téléphone',
                ),
                controller: _phoneController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'Votre localisation',
                ),
                controller: _addressController,
              ),
              TextFormField(
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'Votre sujet de prière',
                ),
                controller: _subjectController,
              ),
              _loading
                  ? const CircularProgressIndicator()
                  : Container(
                      width: screenSize.width,
                      margin: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        child: const Text(
                          'Envoyer',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => send(),
                        // color: kPrimaryColor,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
