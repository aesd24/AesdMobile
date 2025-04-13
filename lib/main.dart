import 'package:aesd_app/providers/event.dart';
import 'package:aesd_app/providers/testimony.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:aesd_app/providers/ceremonies.dart';
import 'package:aesd_app/providers/cinetpay.dart';
import 'package:aesd_app/providers/user.dart';
import 'package:aesd_app/screens/splash_screen.dart';
import '/providers/auth.dart';
import 'providers/church.dart';
import 'providers/quiz.dart';
import 'providers/servant.dart';
import 'providers/singer.dart';
import 'providers/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => User()),
        ChangeNotifierProvider(create: (context) => Church()),
        ChangeNotifierProvider(create: (context) => Servant()),
        ChangeNotifierProvider(create: (context) => Singer()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => Ceremonies()),
        ChangeNotifierProvider(create: (context) => Event()),
        // ChangeNotifierProvider(create: (context) => Quiz()),
        ChangeNotifierProvider(create: (context) => CinetPay()),
        ChangeNotifierProvider(create: (context) => Testimony())
      ],
      child: const MyApp(),
    )
  );
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
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'), // Ajoute le support pour la langue française
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}