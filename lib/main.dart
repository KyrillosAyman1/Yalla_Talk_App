import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/firebase_options.dart';
import 'package:yalla_talk_app/pages/chat_page.dart';
import 'package:yalla_talk_app/pages/login_page.dart';
import 'package:yalla_talk_app/pages/signup_page.dart';
import 'package:yalla_talk_app/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with the default options for the current platform
  // This is necessary to ensure that Firebase is set up before the app runs.
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const YallaTalk());
}

class YallaTalk extends StatelessWidget {
  const YallaTalk({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yalla Talk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        LoginPage.id:(context) =>  LoginPage(),
        SignupPage.id:(context) =>  SignupPage(),
        WelcomePage.id:(context) => const WelcomePage(),
        ChatPage.id: (context) => ChatPage(),
      },
      initialRoute: WelcomePage.id,
    );
  }
}
