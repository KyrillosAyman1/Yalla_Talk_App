import 'package:flutter/material.dart';
import 'package:yalla_talk_app/utils/constants.dart';
import 'package:yalla_talk_app/pages/auth/login_page.dart';
import 'package:yalla_talk_app/pages/auth/signup_page.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static const String id = "welcome_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kSecondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Image.asset(
                  "assets/images/33.png",
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Center(
                  child: Text(
                    "Welcome back",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Lobster",
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, LoginPage.id);
                  },
                  text: "Login",
                  colors: [Colors.transparent, Colors.transparent],
                  hasBorder: true,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, SignupPage.id);
                  },
                  text: "Sign Up",
                  colors: [Colors.white, Colors.white],
                  textColor: Colors.black,
                  hasBorder: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
