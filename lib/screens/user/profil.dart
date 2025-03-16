import 'package:aesd_app/constants/dictionnary.dart';
import 'package:aesd_app/functions/navigation.dart';
import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/screens/auth/recover_account/forgot_password.dart';
import 'package:aesd_app/screens/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfil extends StatefulWidget {
  const UserProfil({super.key, required this.user, this.isSelf = false});

  final UserModel user;
  final bool isSelf;

  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {
  bool subscribed = false;
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isSelf ? null : AppBar(),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * .25,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.green.shade100, blurRadius: 1, spreadRadius: 1)]
                    ),
                    alignment: Alignment.topRight,
                    child: widget.isSelf ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => pushForm(
                            context,
                            destination: RegisterPage(
                              update: true,
                              user: widget.user,
                            )
                          ),
                          icon: const FaIcon(FontAwesomeIcons.pen, size: 20),
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(Colors.amber),
                            iconColor: WidgetStateProperty.all(Colors.amber),
                            overlayColor:
                                WidgetStateProperty.all(Colors.amber.shade100),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.amber.shade50),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.amber, width: 2),
                              borderRadius: BorderRadius.circular(100),
                            ))
                          ),
                        ),
                        IconButton(
                          onPressed: () => pushForm(context,
                            destination: const ForgotPasswordPage()
                          ),
                          icon: FaIcon(FontAwesomeIcons.lockOpen, size: 20),
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(Colors.green),
                            iconColor: WidgetStateProperty.all(Colors.green),
                            overlayColor:
                                WidgetStateProperty.all(Colors.green.shade100),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.green.shade50),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.green, width: 2),
                              borderRadius: BorderRadius.circular(100),
                            ))
                          ),
                        ),
                      ],
                    ) : null,
                  ),
          
                  Positioned(
                    bottom: -40,
                    left: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.user.photo!),
                        ),
                        SizedBox(width: 15),
                        Text(
                          widget.user.name,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
          
              SizedBox(height: 60),
              if(!widget.isSelf && widget.user.accountType == Type.servant.code) Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton.icon(
                    onPressed: () => {}, //onSubscribe(subscribed),
                    icon: FaIcon(
                      subscribed ? FontAwesomeIcons.bookmark :
                      FontAwesomeIcons.solidBookmark
                    ),
                    iconAlignment: IconAlignment.end,
                    label: Text(subscribed ? "Se désabonner" : "S'abonner"),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        subscribed ? Colors.transparent : Colors.blue
                      ),
                      overlayColor: WidgetStateProperty.all(
                        subscribed ? Colors.red.withAlpha(110)
                        : Colors.white.withAlpha(110)
                      ),
                      iconColor: WidgetStateProperty.all(
                        subscribed ? Colors.red : Colors.white
                      ),
                      foregroundColor: WidgetStateProperty.all(
                        subscribed ? Colors.red : Colors.white
                      ),
                      shape: subscribed ? WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          side: const BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.circular(100)
                        )
                      ) : null
                    ),
                  ),
                ),
              ),
              Text("Aucune biographie"),
          
              SizedBox(height: 30),
              
              customRow(
                icon: FontAwesomeIcons.locationDot,
                text: widget.user.adress
              ),
              customRow(
                icon: FontAwesomeIcons.phone,
                text: widget.user.phone
              ),
          
              customRow(
                icon: FontAwesomeIcons.solidEnvelope,
                text: widget.user.email
              ),
          
              customRow(
                icon: FontAwesomeIcons.briefcase,
                text: widget.user.accountType
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FaIcon(icon, size: 17, color: Colors.grey.shade800),
          SizedBox(width: 10),
          Text(text, style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.bold
          ))
        ],
      ),
    );
  }
}