import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/chat/chat_page.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.myContact});
  final UserModel myContact;

  @override
  Widget build(BuildContext context) {
    List<String> roomId = [
      myContact.id!,
      FirebaseAuth.instance.currentUser!.uid,
    ]..sort((a, b) => a.compareTo(b));
    return Card(
      child: ListTile(
        onLongPress: () {
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text("Delete contact"),
            content: Text("Are you sure you want to delete this contact?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {

                  FireData().deleteContact(friendId: myContact.id!);
                  Navigator.pop(context);
                },
              ),
            ],
          ));
        },
        onTap: () {
          FireData().creatChatRoom(email: myContact.email!);
          Navigator.pushNamed(
            context,
            ChatPage.id,
            arguments: {'roomId': roomId.toString(), 'userModel': myContact},
          );
        },
        leading: myContact.image == ""
            ? CircleAvatar(radius: 25, child: Icon(Iconsax.user))
            : GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  PhotoViewPage.id,
                  arguments: myContact.image,
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(myContact.image!),
                ),
              ),
        title: Text(myContact.name!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(myContact.email!, maxLines: 1),
            Text(myContact.about!, maxLines: 1),
          ],
        ),

        trailing: Icon(Iconsax.message),
      ),
    );
  }
}
