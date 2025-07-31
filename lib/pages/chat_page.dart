import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/constants.dart';
import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/widgets/chat_buble.dart';
import 'package:yalla_talk_app/widgets/chat_friend_buble.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static const String id = "chat_page";
  final scrollController = ScrollController();
  CollectionReference messages = FirebaseFirestore.instance.collection(
    'messages',
  );
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessagesModel> messagesList = [];
          for (var message in snapshot.data!.docs) {
            messagesList.add(MessagesModel.fromjson(message));
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,

            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Yalla Talk Chat",
                    style: TextStyle(
                      fontFamily: "Lobster",
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              backgroundColor: kPrimaryClor,
            ),

            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(messagesModel: messagesList[index])
                          : ChatFriendBuble(messagesModel: messagesList[index]);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      messages.add({
                        kMessage: value,
                        kCreatedAt: DateTime.now(),
                        "id": email,
                      });
                      controller.clear();
                      scrollController.jumpTo(0);
                    },

                    decoration: InputDecoration(
                      hintText: "Send Message..",
                      suffixIcon: IconButton(
                        onPressed: () {
                          final text = controller.text;
                          messages.add({
                            kMessage: text,
                            kCreatedAt: DateTime.now(),
                            "id": email,
                          });
                          controller.clear();
                          scrollController.jumpTo(0);
                        },
                        icon: Icon(Icons.send, color: kPrimaryClor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryClor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryClor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {}
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
