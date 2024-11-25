import 'dart:async';

import 'package:aesd_app/components/button.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/screens/new_version/auth/recover_account/change_pass.dart';
import 'package:aesd_app/widgets/auth_overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ValidateOtpPage extends StatefulWidget {
  const ValidateOtpPage({super.key});

  @override
  State<ValidateOtpPage> createState() => _ValidateOtpPageState();
}

class _ValidateOtpPageState extends State<ValidateOtpPage> {
  bool isLoading = false;

  bool canRetry = false;
  Duration timeBeforeRetry = const Duration(minutes: 1, seconds: 30);

  // timer pour le décompte des sécondes
  late Timer _timer;

  Future verifyOTPCode(String code) async {
    pushForm(context, destination: const ChangePasswordPage());
    /* try {
      setState(() {
        isLoading = true;
      });
      print(code);
      await Provider.of<Auth>(context, listen: false).verifyOtp(otpCode: code);
    } on DioException catch (e) {
      e.printError();
      showSnackBar(
          context: context,
          message: "Erreur réseau, vérifier votre connexion internet",
          type: SnackBarType.danger);
    } on HttpException catch (e) {
      showSnackBar(
          context: context, message: e.message, type: SnackBarType.danger);
    } catch (e) {
      showSnackBar(
          context: context,
          message: "Une erreur s'est produite. Veuillez réessayer",
          type: SnackBarType.danger);
    } finally {
      setState(() {
        isLoading = false;
      });
    } */
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeBeforeRetry.inSeconds > 0) {
        timeBeforeRetry -= const Duration(seconds: 1);
        setState(() {
          canRetry = timeBeforeRetry.inSeconds <= 0;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // theme des champs de saisie
    PinTheme defaultTheme = PinTheme(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: Border.all(color: Colors.green, width: 1),
          borderRadius: BorderRadius.circular(7)),
      textStyle: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(color: Colors.green.shade900, fontWeight: FontWeight.bold),
    );

    return AuthOverlayLoading(
      loading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vérification OTP"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Saisissez le code de validation reçu par SMS ou par mail pour pouvoir modifier votre mot de passe",
                ),

                const SizedBox(height: 20),

                Center(
                  child: Pinput(
                    length: 6,
                    defaultPinTheme: defaultTheme,
                    focusedPinTheme: defaultTheme.copyBorderWith(
                        border:
                            Border.all(color: Colors.green.shade900, width: 2)),
                    onCompleted: (value) async => await verifyOTPCode(value),
                  ),
                ),

                const SizedBox(height: 40),

                // Compte à rebours avant que le code ne soit plus valide
                customButton(
                    context: context,
                    text: canRetry
                        ? "Obtenir un nouveau code"
                        : "Patientez ${timeBeforeRetry.inSeconds} secondes",
                    backgroundColor: canRetry ? null : Colors.grey,
                    onPressed: () {
                      if (canRetry) {
                        pushReplaceForm(context,
                            destination: const ValidateOtpPage());
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
