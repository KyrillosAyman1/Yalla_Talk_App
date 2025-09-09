import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';

import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/utils/date_time.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class GroupChatBuble extends StatefulWidget {
  const GroupChatBuble({
    super.key,
    required this.messagesModel,
    required this.roomId,
    required this.isSelected,
  });
  final MessagesModel messagesModel;
  final String roomId;
  final bool isSelected;

  @override
  State<GroupChatBuble> createState() => _GroupChatBubleState();
}

class _GroupChatBubleState extends State<GroupChatBuble> {
  @override
  void initState() {
    if (widget.messagesModel.toId == FirebaseAuth.instance.currentUser!.uid) {
      FireData().readMessage(
        roomId: widget.roomId,
        msgId: widget.messagesModel.id!,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe =
        widget.messagesModel.fromId == FirebaseAuth.instance.currentUser!.uid;
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.messagesModel.fromId)
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Color.fromARGB(255, 137, 156, 179)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.2,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: isMe
                          ? Radius.circular(20)
                          : Radius.circular(0),
                      bottomLeft: isMe
                          ? Radius.circular(0)
                          : Radius.circular(20),
                    ),
                    color: isMe
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.secondaryContainer,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isMe
                          ? SizedBox()
                          : Text(
                              asyncSnapshot.data!.data()!["name"],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                      widget.messagesModel.type == "image"
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PhotoViewPage.id,
                                arguments: widget.messagesModel.message,
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: widget.messagesModel.message!,
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
                            widget.messagesModel.message!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isMe
                              ? Icon(
                                  Icons.done_all_rounded,
                                  color: widget.messagesModel.read == ""
                                      ? Colors.grey
                                      : Colors.blue,
                                )
                              : SizedBox(),
                          SizedBox(width: 6),
                          Text(
                            MyDateTime.getDateTimeString(
                              time: widget.messagesModel.createdAt.toString(),
                            ),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
