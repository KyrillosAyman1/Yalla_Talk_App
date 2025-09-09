// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yalla_talk_app/firebase/fire_auth.dart';
import 'package:yalla_talk_app/helper/validators.dart';
import 'package:yalla_talk_app/helper/firebasea_auth_helper.dart';
import 'package:yalla_talk_app/pages/auth/widgets/custom_screen.dart';
import 'package:yalla_talk_app/utils/constants.dart';
import 'package:yalla_talk_app/helper/show_snack_bar.dart';
import 'package:yalla_talk_app/pages/auth/login_page.dart';
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // عشان الكونتينر مايتحركش
        body: CustomScreen(
          title: "Sign Up",
          widgetData: Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // الجزء اللي بيعمل Scroll
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ), // عشان العناصر ما تتخباش ورا الكيبورد
                    child: Column(
                      children: [
                        const SizedBox(height: 90),

                        CustomTextFormField(
                          validator: Validators.validateSignupName,
                          controller: nameController,
                          color: kPrimaryColor,
                          hintText: "Enter Your Name",
                          labelText: "Name",
                          iconData: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          validator: Validators.validateSignupEmail,
                          controller: emailController,
                          color: kPrimaryColor,
                          onChanged: (data) => email = data,
                          hintText: "Enter Your Email",
                          labelText: "Email",
                          iconData: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          validator: (data) {
                            return Validators.validateSignupPassword(
                              data,
                              confirmPasswordController.text,
                            );
                          },
                          controller: passwordController,
                          color: kPrimaryColor,
                          onChanged: (data) => password = data,
                          hintText: "Enter Your Password",
                          labelText: "Password",
                          iconData: Icons.visibility_off,
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          validator: (data) {
                            return Validators.validateSignupPassword(
                              data,
                              passwordController.text,
                            );
                          },
                          controller: confirmPasswordController,
                          color: kPrimaryColor,
                          hintText: "Enter Your Password Again",
                          labelText: "Confirm Password",
                          iconData: Icons.visibility_off,
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),

                        CustomButton(
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              isLoading = true;
                              setState(() {});
                              try {
                                await FireAuth.signupUser(
                                  email: email,
                                  password: password,
                                );
                                await FirebaseAuth.instance.currentUser!
                                    .updateDisplayName(nameController.text);
                                await FireAuth.createUser();

                                customShowSnackBar(
                                 context:  context,
                                 message:  "✅ Verification email sent! Please check your inbox.",
                                 color: kPrimaryColor
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  LoginPage.id,
                                );
                              } on FirebaseAuthException catch (e) {
                                final errorMessage =
                                    FirebaseAuthHelper.handleSignupAuthError(e);
                                customShowSnackBar(context:  context,message:  errorMessage,color: kPrimaryColor);
                              
                               
                              } catch (e) {
                                customShowSnackBar(context:  context,message:  "Error: $e",color: kPrimaryColor);
                              }
                              isLoading = false;
                              setState(() {});
                            }
                          },
                          text: "Sign Up",
                          colors: [kPrimaryColor, kSecondaryColor],
                        ),
                        const SizedBox(height: 10),

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
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kSecondaryColor,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor: kSecondaryColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/**try {
                                await FireAuth.signupUser(
                                  email: email,
                                  password: password,
                                );
                                await FirebaseAuth.instance.currentUser!
                                    .updateDisplayName(nameController.text);
                                await FireAuth.createUser();

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LayoutApp.id,
                                  (route) => false,
                                  arguments: email,
                                );
                              } on FirebaseAuthException catch (e) {
                                final errorMessage =
                                    FirebaseAuthHelper.handleSignupAuthError(e);
                                customShowSnackBar(context, errorMessage);
                              } */