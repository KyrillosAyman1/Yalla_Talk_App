


/**import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/supabase/supa_storage.dart';
import 'package:yalla_talk_app/utils/constants.dart';
import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/pages/chat/widgets/chat_buble.dart';
import 'package:yalla_talk_app/utils/date_time.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  static const String id = "chat_page";

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final scrollController = ScrollController();

  TextEditingController messageController = TextEditingController();
  List<String> selectedMessages = [];
  List<String> copyedMessages = [];
  bool showScrollToBottom = false;
  @override
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // لو المستخدم مش في آخر الليست => خلي الزرار يظهر
      if (scrollController.offset > 100 && !showScrollToBottom) {
        setState(() => showScrollToBottom = true);
      }
      // لو رجع تاني لآخر الليست => خلي الزرار يختفي
      else if (scrollController.offset <= 100 && showScrollToBottom) {
        setState(() => showScrollToBottom = false);
      }
    });
  }

  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    var roomId = arguments["roomId"];
    var userModel = arguments["userModel"] as UserModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: -30,
        title: ListTile(
          leading: userModel.image == ""
              ? CircleAvatar(radius: 20, child: Icon(Iconsax.user))
              : CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userModel.image!),
                ),
          title: Text(userModel.name!),
          subtitle: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userModel.id)
                .snapshots(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                return Text(
                  asyncSnapshot.data!.data()!["online"]
                      ? "Online"
                      : "Last seen:${MyDateTime.getDateAndTimeString(time: userModel.lastSeen!)} at ${MyDateTime.getDateTimeString(time: userModel.lastSeen!)}",
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
        actions: selectedMessages.isEmpty
            ? [
                IconButton(onPressed: () {}, icon: Icon(Iconsax.call)),
                IconButton(onPressed: () {}, icon: Icon(Iconsax.video)),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert_rounded),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: copyedMessages.join("\n")),
                    );
                    setState(() {
                      selectedMessages = [];
                      copyedMessages = [];
                    });
                  },
                  icon: Icon(Iconsax.copy),
                ),
                IconButton(
                  onPressed: () {
                    FireData().deleteMessage(
                      roomId: roomId,
                      messages: selectedMessages,
                    );
                    setState(() {
                      selectedMessages = [];
                      copyedMessages = [];
                    });
                  },
                  icon: Icon(Iconsax.trash),
                ),
              ],
      ),

      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("rooms")
                      .doc(roomId)
                      .collection("messages")
                      .snapshots(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      List<MessagesModel> messagesList =
                          asyncSnapshot.data!.docs
                              .map((doc) => MessagesModel.fromJson(doc.data()))
                              .toList()
                            ..sort(
                              (a, b) => b.createdAt!.compareTo(a.createdAt!),
                            );
                      return messagesList.isNotEmpty
                          ? ListView.builder(
                              reverse: true,
                              controller: scrollController,
                              itemCount: messagesList.length,
                              itemBuilder: (context, index) {
                                String newDate = "";
                                bool isSameDate = false;

                                if (index == 0) {
                                  newDate = "";
                                } else if (index == messagesList.length - 1) {
                                  newDate = MyDateTime.getDateAndTimeString(
                                    time: messagesList[index].createdAt!,
                                  );
                                } else {
                                  final DateTime date = MyDateTime.getDateTime(
                                    time: messagesList[index].createdAt!,
                                  );
                                  final DateTime preDate =
                                      MyDateTime.getDateTime(
                                        time:
                                            messagesList[index + 1].createdAt!,
                                      );
                                  isSameDate = date.isAtSameMomentAs(preDate);
                                  newDate = isSameDate
                                      ? ""
                                      : MyDateTime.getDateAndTimeString(
                                          time: messagesList[index].createdAt!,
                                        );
                                }

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedMessages.isNotEmpty
                                          ? selectedMessages.contains(
                                                  messagesList[index].id,
                                                )
                                                ? selectedMessages.remove(
                                                    messagesList[index].id,
                                                  )
                                                : selectedMessages.add(
                                                    messagesList[index].id!,
                                                  )
                                          : null;
                                      copyedMessages.isNotEmpty
                                          ? messagesList[index].type == "text"
                                                ? copyedMessages.contains(
                                                        messagesList[index]
                                                            .message,
                                                      )
                                                      ? copyedMessages.remove(
                                                          messagesList[index]
                                                              .message,
                                                        )
                                                      : copyedMessages.add(
                                                          messagesList[index]
                                                              .message!,
                                                        )
                                                : null
                                          : null;
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      selectedMessages.contains(
                                            messagesList[index].id,
                                          )
                                          ? selectedMessages.remove(
                                              messagesList[index].id,
                                            )
                                          : selectedMessages.add(
                                              messagesList[index].id!,
                                            );
                                      messagesList[index].type == "text"
                                          ? copyedMessages.contains(
                                                  messagesList[index].message,
                                                )
                                                ? copyedMessages.remove(
                                                    messagesList[index].message,
                                                  )
                                                : copyedMessages.add(
                                                    messagesList[index]
                                                        .message!,
                                                  )
                                          : null;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      if (newDate != "")
                                        Card(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.inversePrimary,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              newDate,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelLarge,
                                            ),
                                          ),
                                        ),
                                      ChatBuble(
                                        messagesModel: messagesList[index],
                                        roomId: roomId,
                                        isSelected: selectedMessages.contains(
                                          messagesList[index].id,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    FireData().sendMessage(
                                      message: "Hello ${userModel.name}..👋",
                                      roomId: roomId,
                                      friendId: userModel.id!,
                                    );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "👋",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.displayMedium,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Say Hello ${userModel.name}..",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: TextField(
                          maxLines: 6,
                          minLines: 1,
                          controller: messageController,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              FireData().sendMessage(
                                message: value,
                                roomId: roomId,
                                friendId: userModel.id!,
                              );
                            }
                            messageController.clear();
                            scrollController.jumpTo(0);
                          },

                          decoration: InputDecoration(
                            hintText: "Send Message..",
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Iconsax.emoji_happy5),
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (image != null) {
                                      SupaStorage().uploadImage(
                                        file: File(image.path),
                                        roomId: roomId,
                                        uId: userModel.id!,
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.camera_alt_outlined),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.attach_file),
                                ),
                              ],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: kPrimaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: kPrimaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        if (messageController.text.isNotEmpty) {
                          FireData().sendMessage(
                            message: messageController.text,
                            roomId: roomId,
                            friendId: userModel.id!,
                          );
                        }
                        messageController.clear();
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(0);
                        }
                      },
                      icon: Icon(Iconsax.send_1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          showScrollToBottom
              ? Positioned(
                  left: 10,
                  bottom: 100,
                  child: IconButton.filledTonal(
                    onPressed: () {
                      scrollController.jumpTo(0);
                    },
                    icon: Icon(
                      Icons.keyboard_double_arrow_down_outlined,
                      size: 20,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
 */




















/*
 import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';

import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/utils/date_time.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class ChatBuble extends StatefulWidget {
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
  State<ChatBuble> createState() => _ChatBubleState();
}

class _ChatBubleState extends State<ChatBuble> {
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
      child: Container(
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
                bottomRight: isMe ? Radius.circular(20) : Radius.circular(0),
                bottomLeft: isMe ? Radius.circular(0) : Radius.circular(20),
              ),
              color: isMe
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.messagesModel.type == "image"
                    ? GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PhotoViewPage.id,arguments: widget.messagesModel.message);
                      },
                      child: CachedNetworkImage(
                          imageUrl: widget.messagesModel.message!,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 300,
                          width: 250,
                      ),
                    )                    
                    : 
                Text(
                  widget.messagesModel.message!,
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               SizedBox(height: 2,),
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
                        time: widget.messagesModel.createdAt!,
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
  }
} */