import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/utils/date_time.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.messagesModel,
    required this.roomId,
    required this.isSelected,
  });

  final MessagesModel messagesModel;
  final String roomId;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .doc(messagesModel.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final msg =
            MessagesModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

        bool isMe = msg.fromId == FirebaseAuth.instance.currentUser!.uid;

        // اول ما الرسالة تتعرض عند المستلم، نخليها مقروءة
        if (msg.toId == FirebaseAuth.instance.currentUser!.uid &&
            msg.read == "") {
          FireData().readMessage(roomId: roomId, msgId: msg.id!);
        }

        return Align(
          alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 137, 156, 179)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.2,
                ),
                padding: const EdgeInsets.all(10),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomRight:
                        isMe ? const Radius.circular(20) : const Radius.circular(0),
                    bottomLeft:
                        isMe ? const Radius.circular(0) : const Radius.circular(20),
                  ),
                  color: isMe
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    msg.type == "image"
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PhotoViewPage.id,
                                arguments: msg.message,
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: msg.message!,
                              placeholder: (context, url) =>
                                  const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                               
                              height: 300,
                              width: 250,
                            ),
                          )
                        : Text(
                            msg.message!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isMe
                            ? Icon(
                                Icons.done_all_rounded,
                                color: msg.read == "" ? Colors.grey : Colors.blue,
                              )
                            : const SizedBox(),
                        const SizedBox(width: 6),
                        Text(
                          MyDateTime.getDateTimeString(
                            time: msg.createdAt!,
                          ),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
