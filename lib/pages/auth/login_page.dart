// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yalla_talk_app/firebase/fire_auth.dart';
import 'package:yalla_talk_app/helper/validators.dart';
import 'package:yalla_talk_app/helper/firebasea_auth_helper.dart';
import 'package:yalla_talk_app/pages/home/layout_app.dart';
import 'package:yalla_talk_app/pages/auth/forget_page.dart';
import 'package:yalla_talk_app/pages/auth/widgets/custom_screen.dart';
import 'package:yalla_talk_app/utils/constants.dart';
import 'package:yalla_talk_app/helper/show_snack_bar.dart';
import 'package:yalla_talk_app/pages/auth/signup_page.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = "login_page";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScreen(
          title: "Login",
          widgetData: Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                          validator: Validators.validateLoginEmail,
                          controller: emailcontroller,
                          color: kPrimaryColor,
                          onChanged: (value) {
                            final cursorPos = emailcontroller.selection;

                            // تعديل النص
                            emailcontroller.value = emailcontroller.value
                                .copyWith(
                                  text: value, // أو أي تعديل على النص
                                  selection: cursorPos, // إعادة موقع الكرسر
                                );
                          },
                          hintText: "Enter Your Email",
                          labelText: "Email",
                          iconData: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          validator: Validators.validateLoginPassword,
                          controller: passwordcontroller,
                          color: kPrimaryColor,
                          onChanged: (value) {
                            final cursorPos = passwordcontroller.selection;

                            // تعديل النص
                            passwordcontroller.value = passwordcontroller.value
                                .copyWith(
                                  text: value, // أو أي تعديل على النص
                                  selection: cursorPos, // إعادة موقع الكرسر
                                );
                          },
                          hintText: "Enter Your Password",
                          labelText: "Password",
                          iconData: Icons.visibility_off,
                          isPassword: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, ForgetPage.id);
                            },
                            child: Text(
                              "Forget Password?",
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
                        const SizedBox(height: 20),
                        CustomButton(
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await FireAuth().signInUser(
                                  email: emailcontroller.text.trim(),
                                  password: passwordcontroller.text.trim(),
                                );

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LayoutApp.id,
                                  (route) => false,
                                  arguments: emailcontroller.text.trim(),
                                );
                              } on FirebaseAuthException catch (e) {
                                final message =
                                    FirebaseAuthHelper.handleLoginAuthError(e);
                                customShowSnackBar(
                                  context: context,
                                  message: message,
                                  color: kPrimaryColor,
                                );
                              } catch (e) {
                                customShowSnackBar(
                                  context: context,
                                  message: "An error occurred: $e",
                                  color: kPrimaryColor,
                                );
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {}
                          },
                          text: "Login",
                          colors: [kPrimaryColor, kSecondaryColor],
                        ),
                        const SizedBox(height: 10),
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
                                  Navigator.pushReplacementNamed(
                                    context,
                                    SignupPage.id,
                                  );
                                },
                                child: Text(
                                  "Sign Up",
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
                                await FireAuth().signInUser(
                                  email: emailcontroller.text.trim(),
                                  password: passwordcontroller.text.trim(),
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LayoutApp.id,
                                  (route) => false,
                                  arguments:  emailcontroller.text.trim(),
                                );
                              } on FirebaseAuthException catch (e) {
                                final message =
                                    FirebaseAuthHelper.handleLoginAuthError(e);
                                customShowSnackBar(context, message);
                              }  */
