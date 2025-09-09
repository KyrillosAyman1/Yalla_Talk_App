import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/chat/widgets/custom_card_profile.dart';

import 'package:yalla_talk_app/utils/photo_view_page.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});
  static const String id = 'profile_details';

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                arguments.image == ""
                    ? const CircleAvatar(
                        radius: 90,
                        child: Icon(Iconsax.user, size: 90),
                      )
                    : GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          PhotoViewPage.id,
                          arguments: arguments.image,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          radius: 93,
                          child: CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(arguments.image!),
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                CustomCardProfile(
                  title: "Name",
                  subtitle: arguments.name!,
                  icon: Iconsax.user,
                ),
                SizedBox(height: 7),

                CustomCardProfile(
                  title: "Email",
                  subtitle: arguments.email!,
                  icon: Icons.email_outlined,
                ),
                SizedBox(height: 7),

               

                CustomCardProfile(
                  title: "About",
                  subtitle: arguments.about!,
                  icon: Iconsax.information,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
