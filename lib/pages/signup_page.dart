import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yalla_talk_app/constants.dart';
import 'package:yalla_talk_app/helper/show_snack_bar.dart';
import 'package:yalla_talk_app/pages/chat_page.dart';
import 'package:yalla_talk_app/pages/login_page.dart';
import 'package:yalla_talk_app/widgets/custom_background.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static String id = "signup_page";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? email;

  String? password;

  GlobalKey<FormState> formkey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading, 
      child: Scaffold(
        resizeToAvoidBottomInset: true,
      
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const CustomBackground(title: "Sign Up"), // الباكجراوند المخصص
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                color: Colors.white.withAlpha((0.7 * 255).round()),
              ),
              height: MediaQuery.of(context).size.height * 0.80,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
      
                child: Form(
                  key: formkey,
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 110),
                      CustomTextFormField(
                        hintText: "Enter Your Name",
                        labelText: "Name",
                        iconData: Icons.person,
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        onChanged: (data) {
                          email = data;
                        },
                        hintText: "Enter Your Email",
                        labelText: "Email",
                        iconData: Icons.email,
                      ),
      
                      SizedBox(height: 20),
      
                      CustomTextFormField(
                        onChanged: (data) {
                          password = data;
                        },
                        hintText: "Enter Your Password",
                        labelText: "Password",
                        iconData: Icons.visibility_off,
                        isPassword: true,
                      ),
      
                      SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: "Enter Your Password Again",
                        labelText: "Confirm Password",
                        iconData: Icons.visibility_off,
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        onTap: () async {
                          if (formkey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {
                              
                            });
                            try {
                              await signupUser(); 
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                ChatPage.id,
                                (route) => false,
                                arguments: email,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                showSnackBar(context, "Weak password");
                              } else if (e.code == 'email-already-in-use') {
                                showSnackBar(context, "Email already in use");
                              } else {
                                showSnackBar(context, "Error: ${e.message}");
                              }
                            } catch (e) {
                              showSnackBar(context, "Error: $e");
                            }
                            isLoading = false;
                            setState(() {
                              
                            });
                          } else {
                           
                          }
                           
                        },
                        text: "Sign Up",
                        colors: [kPrimaryClor, kSecondaryColor],
                      ),
      
                      SizedBox(height: 10),
      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, LoginPage.id);
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> signupUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
