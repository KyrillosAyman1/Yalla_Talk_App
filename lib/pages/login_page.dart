import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yalla_talk_app/constants.dart';
import 'package:yalla_talk_app/helper/show_snack_bar.dart';
import 'package:yalla_talk_app/pages/chat_page.dart';
import 'package:yalla_talk_app/pages/signup_page.dart';
import 'package:yalla_talk_app/widgets/custom_background.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = "login_page";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const CustomBackground(title: "Login"), // الباكجراوند المخصص

            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -3),
                    blurRadius: 20,
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
                    children: [
                      SizedBox(height: 120),
                      CustomTextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        hintText: "Enter Your Email",
                        labelText: "Email",
                        iconData: Icons.email,
                      ),

                      SizedBox(height: 20),

                      CustomTextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        hintText: "Enter Your Password",
                        labelText: "Password",
                        iconData: Icons.visibility_off,
                        isPassword: true,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: Text("Forget Password?", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                 
                                ),),
                        ),
                      ),
                      SizedBox(height: 20),

                      CustomButton(
                        onTap: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await signInUser();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                ChatPage.id,
                                (route) => false,
                                arguments: email,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showSnackBar(
                                  context,
                                  "No user found for that email.",
                                );
                              } else if (e.code == 'wrong-password') {
                                showSnackBar(context, "wrong password");
                              } else {
                                print(e);
                                showSnackBar(context, "error: ${e.message}");
                              }
                            } catch (e) {
                              showSnackBar(context, "An error occurred: $e");
                            }
                            setState(() {
                              isLoading = false;
                            });
                          } else {}
                        },
                        text: "Login",
                        colors: [kPrimaryClor, kSecondaryColor],
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, SignupPage.id);
                              },
                              child: Text(
                                "Sign Up",
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

  Future<void> signInUser() async {
    final UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
