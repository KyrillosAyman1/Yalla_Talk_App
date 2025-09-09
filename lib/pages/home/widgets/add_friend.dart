// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/helper/show_snack_bar.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({
    super.key,
    required this.emailFriendController,
     this.createChat = false,
  });
  final TextEditingController emailFriendController;
  final bool createChat;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Divider(
              indent: 150,
              endIndent: 150,
              thickness: 7,
              radius: BorderRadius.circular(15),
            ),
          ),
          SizedBox(height: 15),

          Row(
            children: [
              Text(
                "Enter Friend Email",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Spacer(),
              IconButton.filled(
                onPressed: () {},
                icon: Icon(Iconsax.scan_barcode),
              ),
            ],
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            controller: emailFriendController,
            hintText: "Enter Friend Email",
            labelText: "Friend Email",
            iconData: Icons.email,
          ),
          SizedBox(height: 20),

          CustomButton(
            text: createChat ? "Create Chat" : "Add Friend",
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primary,
            ],
            onTap: () async {
              final userSnapshot = await FireData().getUserByEmail(
                emailFriendController.text,
              );

              if (emailFriendController.text.isNotEmpty) {
                if (userSnapshot == null) {
                  // مش موجود
                  Navigator.pop(context);
                  customShowSnackBar(context: context, message:  "This email does not exist");
                  emailFriendController.clear();
                  return;
                } else if (createChat) {
                  FireData().creatChatRoom(email: emailFriendController.text);
                  FireData().addContact(email: emailFriendController.text);
                  Navigator.pop(context);
                  emailFriendController.clear();
                  customShowSnackBar(context : context, message:  "Chat Created Successfully");
                } else {
                  FireData().addContact(email: emailFriendController.text);
                  emailFriendController.clear();
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
                customShowSnackBar ( context:  context,message:  "Please Enter Friend Email");
              }
            },
          ),
        ],
      ),
    );
  }
}
