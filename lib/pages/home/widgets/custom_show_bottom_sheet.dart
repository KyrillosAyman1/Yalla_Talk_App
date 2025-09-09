import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class CustomShowBottomSheet extends StatelessWidget {
  final String buttonText;
  const CustomShowBottomSheet({super.key, required this.buttonText});
  @override
  Widget build(BuildContext context) {
    TextEditingController emailFriendController = TextEditingController();
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
            text: buttonText,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primary,
            ],
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
