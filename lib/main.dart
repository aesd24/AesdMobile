import 'package:aesd_app/providers/ceremonies.dart';
import 'package:aesd_app/providers/cinetpay.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/splash_screen.dart';
//import 'package:aesd_app/screens/splash_screen.dart';
import '/providers/auth.dart';
import 'providers/chat.dart';
import 'providers/church.dart';
import 'providers/donation.dart';
import 'providers/message.dart';
import 'providers/quiz.dart';
import 'providers/servant.dart';
import 'providers/singer.dart';
import 'providers/forum.dart';
import 'providers/post.dart';
import 'providers/job.dart';
import 'providers/course.dart';
import 'providers/participant.dart';
import 'utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Auth()),
      ChangeNotifierProvider(create: (context) => User()),
      ChangeNotifierProvider(create: (context) => Church()),
      ChangeNotifierProvider(create: (context) => Servant()),
      ChangeNotifierProvider(create: (context) => Singer()),
      ChangeNotifierProvider(create: (context) => Forum()),
      ChangeNotifierProvider(create: (context) => Post()),
      ChangeNotifierProvider(create: (context) => Ceremonies()),
      ChangeNotifierProvider(create: (context) => Job()),
      ChangeNotifierProvider(create: (context) => Course()),
      ChangeNotifierProvider(create: (context) => Donation()),
      ChangeNotifierProvider(create: (context) => Quiz()),
      ChangeNotifierProvider(create: (context) => Chat()),
      ChangeNotifierProvider(create: (context) => Message()),
      ChangeNotifierProvider(create: (context) => Participant()),
      ChangeNotifierProvider(create: (context) => CinetPay())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AESD',
      theme: ThemeData(
        fontFamily: "Manrope",
        iconTheme: IconThemeData(color: Colors.grey.shade500),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const SplashScreen(),
      routes: routes,
    );
  }
}