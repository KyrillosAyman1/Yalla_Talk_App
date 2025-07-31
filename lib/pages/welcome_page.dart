import 'package:flutter/material.dart';
import 'package:yalla_talk_app/constants.dart';
import 'package:yalla_talk_app/pages/login_page.dart';
import 'package:yalla_talk_app/pages/signup_page.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
   static const String id = "welcome_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimaryClor, kSecondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
               // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height:MediaQuery.of(context).size.height * 0.06,
                  ),
                  //Spacer(flex: 2),
                  Image.asset("assets/images/33.png",
                    height: MediaQuery.of(context).size.height * 0.3,
                   
                  ),
                  SizedBox(
                    height:MediaQuery.of(context).size.height * 0.07,
                  ),
                  //Spacer(flex: 1),
                  Center(
                    child: Text("Welcome back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lobster",
                      ),
                    ),
                  ),
                  SizedBox(
                    height:MediaQuery.of(context).size.height * 0.06,
                  ),
                 // Spacer(flex: 1),
                  CustomButton(
                    onTap: (){
                      Navigator.pushNamed(context, LoginPage.id);
                    },
                    text: "Login",
                    colors: [Colors.transparent,Colors.transparent],
                    hasBorder: true,
                  ),
                 SizedBox(
                    height:MediaQuery.of(context).size.height * 0.03,
                  ),
                  CustomButton(
                    onTap: (){
                      Navigator.pushNamed(context, SignupPage.id);
                    },
                    text: "Sign Up",
                    colors: [Colors.white,Colors.white],
                    textColor: Colors.black,
                    hasBorder: true,
                  ),
                  //Spacer(flex: 2),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}

/**const Center(
              child: Text(
                "Welcome to Yalla Talk",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Pacifico",
                ),
              ),
            ), */