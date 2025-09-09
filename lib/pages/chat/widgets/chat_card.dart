import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/chats_model.dart';
import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/chat/chat_page.dart';
import 'package:yalla_talk_app/utils/date_time.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.chatsModel});
  final ChatsModel chatsModel;

  @override
  Widget build(BuildContext context) {
    var roomId = chatsModel.id!;
    List members = chatsModel.members!
        .where((e) => e != FirebaseAuth.instance.currentUser!.uid)
        .toList();
    String friendId = members.isEmpty
        ? FirebaseAuth.instance.currentUser!.uid
        : members.first;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .snapshots(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          UserModel userModel = UserModel.fromJson(asyncSnapshot.data!.data());
          return Card(
            child: ListTile(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete chat"),
                    content: const Text(
                      "Are you sure you want to delete this chat?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                        
                      ),
                      TextButton(
                        onPressed: () {
                          FireData().deleteRoom(roomId: roomId);
                          Navigator.pop(context);
                        },
                        child: const Text("Delete chat"),
                      ),
                    ],
                  ),
                );

                /** showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete chat"),
                    content: const Text("Are you sure you want to delete this chat?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(roomId)
                              .delete();
                        }
                        }, */
              },
              onTap: () => Navigator.pushNamed(
                context,
                ChatPage.id,
                arguments: {'roomId': roomId, 'userModel': userModel},
              ),
              leading: userModel.image == ""
                  ? CircleAvatar(radius: 25, child: Icon(Iconsax.user))
                  : GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        PhotoViewPage.id,
                        arguments: userModel.image,
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(userModel.image!),
                      ),
                    ),

              title: Text(
                userModel.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                chatsModel.lastMessage == ""
                    ? userModel.about!
                    : chatsModel.lastMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                children: [
                  Text(
                    "${MyDateTime.getDateAndTimeString(time: chatsModel.lastMessageTime!).toString()} at ${MyDateTime.getDateTimeString(time: chatsModel.lastMessageTime!)}",
                  ),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("rooms")
                        .doc(roomId)
                        .collection("messages")
                        .where(
                          "toId",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .where("read", isEqualTo: "")
                        .snapshots(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        final unReadList = asyncSnapshot.data?.docs.map(
                          (e) => MessagesModel.fromJson(e.data()),
                        );

                        return unReadList!.isNotEmpty
                            ? Badge(
                                label: Text(
                                  unReadList.length.toString(),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                largeSize: 25,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              )
                            : SizedBox();
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
