// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yalla_talk_app/helper/validators.dart';
import 'package:yalla_talk_app/helper/custom_show_dialog.dart';
import 'package:yalla_talk_app/pages/auth/widgets/custom_screen.dart';
import 'package:yalla_talk_app/utils/constants.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});
  static const String id = "forget";

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScreen(
          title: "Reset Password",
          widgetData: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 120),
                  CustomTextFormField(
                    validator: Validators.validateResetPassword,
                    controller: emailcontroller,
                    color: kPrimaryColor,
                    onChanged: (value) {
                      emailcontroller.text = value;
                    },
                    hintText: "Enter Your Email",
                    labelText: "Email",
                    iconData: Icons.email,
                  ),

                  SizedBox(height: 30),

                  CustomButton(
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailcontroller.text,
                          );
                          Navigator.pop(context);
                          customShowDialog(
                          context:  context,
                           title:  "Check Your Email",
                          content:    "we have sent a password reset link to your email",
                          color: kPrimaryColor
                          );
                        } on FirebaseAuthException catch (e) {
                          customShowDialog(context:  context, title: "Error", content: e.message!,color: kPrimaryColor);
                        } on Exception catch (e) {
                          customShowDialog(context:  context, title: "Error", content: e.toString(),color: kPrimaryColor);
                        }
                      }
                    },
                    text: "Send Code",
                    colors: [kPrimaryColor, kSecondaryColor],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
